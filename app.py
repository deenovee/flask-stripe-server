from flask import Flask, jsonify
import stripe

app = Flask(__name__)
stripe.api_key = 'sk_.......'

app.CONFIG['CANCEL_URL'] = 'https://example.com/cancel'
app.CONFIG['SUCCESS_URL'] = 'https://example.com/success'

@app.route('/', methods=['GET'])
def get_products():
    products = stripe.Product.list()
    return jsonify(products)

@app.route('/create-checkout-session', methods=['POST'])
def create_checkout_session():
    line_items = request.get_json()
    #create checkout session
    session = stripe.checkout.Session.create(
        line_items=line_items,
        mode='payment',
        success_url=SUCCESS_URL,  # Change to your actual success URL
        cancel_url=CANCEL_URL,    # Change to your actual cancel URL
        billing_address_collection='required',
        shipping_address_collection={
            'allowed_countries': ['US', 'CA', 'GB', 'AU'],  # Specify the allowed countries for shipping

        },
    )   
    return jsonify({'url': session.url})