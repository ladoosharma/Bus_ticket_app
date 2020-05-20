public with sharing class Ticket_details {
    public class Payer {
		public String payment_method;
        public Payer(){
            payment_method= 'paypal';
        }
	}

	public class Transactions {
		public Amount amount;
		public String invoice_number;
		public Payment_options payment_options;
        public transactions(amount amt, Payment_options poption){
            invoice_number = String.valueof(Math.random());
            payment_options = poption;
            amount = amt;
        }
	}

	public class Amount {
		public String total;
		public String currency_x;
        public amount (Decimal amount){
            total = String.valueOf(amount);
            currency_x ='INR';
        }
	}

	public class Redirect_urls {
		public String return_url ;
		public String cancel_url ;
        public Redirect_urls(String urlSuccess , String urlFailure){
            return_url = urlSuccess;
            cancel_url = urlFailure;
        }
	}

	public class Payment_options {
		public String allowed_payment_method;
        public payment_options(){
            allowed_payment_method = 'INSTANT_FUNDING_SOURCE';
        }
	}

	public String intent;
	public Payer payer;
	public List<Transactions> transactions;
	public String note_to_payer;
	public Redirect_urls redirect_urls;
	
    public Ticket_details(Decimal total_cost, String successUrl, String failureUrl){
        intent = 'sale';
        payer = new Ticket_details.Payer();
        Ticket_details.Amount amout = new Ticket_details.Amount(total_cost);
        Ticket_details.Payment_options option = new Ticket_details.Payment_options();
        transactions = new List<Transactions>{new Ticket_details.Transactions(amout, option)};
        successUrl = successUrl+'&c__invoice='+  transactions[0].invoice_number;
        note_to_payer = 'Contact us for any questions on your order.';
        redirect_urls = new Ticket_details.Redirect_urls(successUrl, failureUrl);
        
        //transactions = new List<Transactions>{new Ticket_details.Transactions(amout, option)};
    }
	
}