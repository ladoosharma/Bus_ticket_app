public class Payment_Callback_Class {

	public class Payer {
		public String payment_method;
	}

	public class Transactions {
		public Amount amount;
		public String invoice_number;
		public Payment_options payment_options;
		public List<Related_resources> related_resources;
	}

	public String id;
	public String intent;
	public String state;
	public Payer payer;
	public List<Transactions> transactions;
	public String note_to_payer;
	public String create_time;
	public List<Links> links;

	public class Amount {
		public String total;
		public String currency_x;
	}

	public class Payment_options {
		public String allowed_payment_method;
		public Boolean recurring_flag;
		public Boolean skip_fmf;
	}

	public class Related_resources {
	}

	public class Links {
		public String href;
		public String rel;
		public String method;
	}

	
	public static Payment_Callback_Class parse(String json) {
		return (Payment_Callback_Class) System.JSON.deserialize(json, Payment_Callback_Class.class);
	}
}