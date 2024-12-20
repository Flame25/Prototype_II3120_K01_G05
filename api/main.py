from flask import Flask, jsonify, request
from supabase import Client, create_client
from datetime import datetime
import pytz

SUPABASE_URL = "https://zstlvfrubmxryjbpaxdd.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzdGx2ZnJ1Ym14cnlqYnBheGRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzOTcyNTEsImV4cCI6MjA0OTk3MzI1MX0.FYsDnVLeBO2vIFkNZs5D2psyrt2gpjw-yNz8LDu_sv8"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Initialize Flask app
app = Flask(__name__)

def utc_to_local(utc_time_str):
    # Parse the UTC time string into a datetime object
    utc_dt = datetime.fromisoformat(utc_time_str)
    # Define timezones
    utc_zone = pytz.utc
    jakarta_zone = pytz.timezone("Asia/Jakarta")
    # Convert UTC to Jakarta timezone
    local_dt = utc_dt.astimezone(jakarta_zone)
    return local_dt

# Function to calculate time difference ignoring the date
def time_difference(time1, time2):

    # Extract time only (ignore date)
    time1 = time1.time()
    time2 = time2.time()

    # Calculate time difference ignoring days
    time_diff = (datetime.combine(datetime.min, time1) - datetime.combine(datetime.min, time2)).total_seconds()
    return time_diff


@app.route('/timetable', methods=['POST'])
def get_route_timetable():
    """
    Fetch timetable from Supabase and find the closest upcoming time for a given route_id.
    """
    # Get JSON data from request body
    data = request.json
    route_id = data.get('route_id')
    request_time_str = data.get('time')

    # Validate input
    if not route_id:
        return jsonify({"error": "Route ID is required."}), 400
    if not request_time_str:
        return jsonify({"error": "Time is required."}), 400

    try:
        request_time = datetime.fromisoformat(request_time_str)
    except ValueError:
        return jsonify({"error": "Invalid datetime format. Use ISO 8601 format."}), 400

    # Fetch route from the `route` table using route_id
    route_response = supabase.table("route").select("route_info").eq("id", route_id).execute()

    if route_response.data:
        route_data = route_response.data[0]
        route_json = route_data.get("route_info")
        route_list = route_json.get("route")
        print(route_list)

        if not route_list or not isinstance(route_list, list) or len(route_list) == 0:
            return jsonify({"error": f"Invalid or empty route data for route_id '{route_id}'."}), 404

        # The first station determines the timetable
        first_station = route_list[0]

        # Query Supabase for timetable data
        timetable_response = supabase.table("timetable").select("*").eq("route_info", route_id).execute()

        if timetable_response.data:
            timetable = timetable_response.data
            if not timetable:
                return jsonify({"error": "No timetable data found."}), 404

            # Find the column matching the first station
            first_station_data = []
            for row in timetable:
                if first_station in row:
                    first_station_data.append(row[first_station])

            if not first_station_data:
                return jsonify({"error": f"No timetable found for the first station '{first_station}'."}), 404

            # Convert all time zone to jakarta (WIB)
            for i in range(0, len(first_station_data)):
                first_station_data[i] = str(utc_to_local(first_station_data[i]))

            # Find the closest upcoming time for the first station
            closest_time = None
            min_time_diff = float('inf')

            for time_str in first_station_data:
                try:
                    time_entry = datetime.fromisoformat(time_str)
                except ValueError:
                    continue  # Skip invalid datetime entries

                time_diff = time_difference(time_entry, request_time)
                if 0 <= time_diff < min_time_diff:
                    closest_time = time_entry
                    min_time_diff = time_diff

            choosen_route_time = []
            for row in timetable:
                print(closest_time)
                print(utc_to_local(row[first_station]))
                if closest_time == utc_to_local(row[first_station]):
                    for i in route_list:
                        choosen_route_time.append(utc_to_local(row[i]))

            if closest_time:
                return jsonify({
                    "route_id": route_id,
                    "timetable": [time.isoformat() for time in choosen_route_time],
                    "route": route_list,
                    "start_station": first_station,
                    "closest_time": closest_time.isoformat()
                })
            else:
                return jsonify({"message": "No upcoming times found for the specified route."}),404
        else:
            return jsonify({"error": f"Error fetching timetable: {timetable_response.status_code}"}),500
    else:
        return jsonify({"error": f"No route found for route_id '{route_id}'."}),404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
