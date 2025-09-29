import json
import random
import uuid
from datetime import datetime, timedelta

def generate_user_base(num_users):
    """
    Generates a list of unique user and location data
    """

    users = []
    locations = []
    countries = ["USA", "Canada", "UK", "Germany", "France", "Japan", "Australia", "Poland"]
    cities = {
        "USA": [("New York", 40.71, -74.01), ("Los Angeles", 34.05, -118.24), ("Chicago", 41.88, -87.63), ("Houston", 29.76, -95.37)],
        "Canada": [("Toronto", 43.65, -79.38), ("Vancouver", 49.28, -123.12), ("Montreal", 45.50, -73.57), ("Calgary", 51.05, -114.07)],
        "UK": [("London", 51.51, -0.13), ("Manchester", 53.48, -2.24), ("Birmingham", 52.48, -1.89), ("Edinburgh", 55.95, -3.19)],
        "Germany": [("Berlin", 52.52, 13.41), ("Munich", 48.14, 11.58), ("Frankfurt", 50.11, 8.68), ("Hamburg", 53.55, 9.99)],
        "France": [("Paris", 48.86, 2.35), ("Lyon", 45.76, 4.83), ("Marseille", 43.30, 5.37), ("Nice", 43.70, 7.25)],
        "Japan": [("Tokyo", 35.68, 139.76), ("Osaka", 34.69, 135.50), ("Kyoto", 35.01, 135.77), ("Nagoya", 35.18, 136.90)],
        "Australia": [("Sydney", -33.87, 151.21), ("Melbourne", -37.81, 144.96), ("Brisbane", -27.47, 153.03), ("Perth", -31.95, 115.86)],
        "Poland": [("Warsaw", 52.23, 21.01), ("Krakow", 50.06, 19.94), ("Wroclaw", 51.11, 17.03), ("Gdansk", 54.35, 18.65)],
    }
    first_names = ["Alex", "Sarah", "John", "Maria", "David", "Emily", "Chris", "Jessica", "Michael", "Olivia", "Daniel", "Sophia", "James", "Isabella"]
    last_names = ["Smith", "Jones", "Williams", "Brown", "Taylor", "Miller", "Davis", "Wilson", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin"]

    for i in range(1, num_users + 1):
        user_id = str(uuid.uuid4())
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)

        country = random.choice(countries)
        city_data = random.choice(cities.get(country, [("Unknown City", 0.0, 0.0)]))
        city, lat, lon = city_data

        users.append({
            "record_id": i,
            "user_id": user_id,
            "first_name": first_name,
            "last_name": last_name,
            "email": f"{first_name.lower()}.{last_name.lower()}{random.randint(1, 99)}@email.com",
        })

        locations.append({
            "user_id": user_id,
            "location_id": str(uuid.uuid4()),
            "country": country,
            "city": city,
            "latitude": lat + random.uniform(-0.1, 0.1),
            "longitude": lon + random.uniform(-0.1, 0.1),
            "timezone": f"UTC{random.choice([-5, 0, 9])}"
        })

    return users, locations

def generate_orders(users, num_orders):
    """
    Generates order data, linking to a random user.
    """

    orders = []
    product_categories = ["Electronics", "Apparel", "Home Goods", "Books", "Software", "Food", "Automotive", "Health"]
    transaction_types = ["Purchase", "Refund", "Subscription", "Renewal", "Pre-order"]
    payment_methods = ["Credit Card", "PayPal", "Bank Transfer", "Crypto", "Gift Card", "Debit Card", "Apple Pay", "Google Pay", "Cash"]

    for i in range(1, num_orders + 1):
        user = random.choice(users)

        end_date = datetime.now()
        start_date = end_date - timedelta(days=365)
        random_date = start_date + (end_date - start_date) * random.random()

        orders.append({
            "order_record_id": i,
            "order_id": f"ORD-{random.randint(10000000, 99999999)}",
            "user_id": user["user_id"],
            "transaction_date": random_date.isoformat(),
            "transaction_amount": round(random.uniform(6.50, 1200.99), 2),
            "currency": random.choice(["USD", "EUR", "JPY", "GBP", "CAD", "AUD"]),
            "product_category": random.choice(product_categories),
            "transaction_type": random.choice(transaction_types),
            "payment_method": random.choice(payment_methods),
            "items_count": random.randint(1, 25),
        })

    return orders

def generate_large_json_file(num_users, num_orders, filename):
    """
    Generates the main JSON structure with three arrays.
    """
    print(f"Generating {num_users} users and {num_orders} orders...")

    users, locations = generate_user_base(num_users)
    orders = generate_orders(users, num_orders)
    data = {
        "users": users,
        "orders": orders,
        "locations": locations
    }

    print(f"Writing data to {filename} with three internal arrays...")

    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"Successfully created {filename}.")

if __name__ == "__main__":
    NUM_USERS = 500
    NUM_ORDERS = 10000
    OUTPUT_FILENAME = "../data/raw_records.json"

    generate_large_json_file(NUM_USERS, NUM_ORDERS, OUTPUT_FILENAME)
