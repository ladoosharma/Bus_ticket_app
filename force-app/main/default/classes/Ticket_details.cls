public with sharing class Ticket_details {
    public class Payer {
		public String payment_method;
	}

	public class Transactions {
		public Amount amount;
		public String description;
		public String custom;
		public String invoice_number;
		public Payment_options payment_options;
		public String soft_descriptor;
		public Item_list item_list;
	}

	public class Details {
		public String subtotal;
	}

	public String intent;
	public Payer payer;
	public List<Transactions> transactions;
	public String note_to_payer;
	public Redirect_urls redirect_urls;

	public class Item_list {
		public List<Items> items;
		public Shipping_address shipping_address;
	}

	public class Amount {
		public String total;
		public String currency_x;
		public Details details;
	}

	public class Redirect_urls {
		public String return_url;
		public String cancel_url;
	}

	public class Payment_options {
		public String allowed_payment_method;
	}

	public class Items {
		public String name;
		public String description;
		public String quantity;
		public String price;
		public String currency_x;
	}

	public class Shipping_address {
		public String recipient_name;
		public String line1;
		public String line2;
		public String city;
		public String country_code;
		public String postal_code;
		public String phone;
		public String state;
	}

	
	public static Ticket_details parse(String json) {
		return (Ticket_details) System.JSON.deserialize(json, Ticket_details.class);
	}
}
