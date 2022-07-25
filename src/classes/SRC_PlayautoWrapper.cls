global with sharing class SRC_PlayautoWrapper {
    global SRC_PlayautoWrapper() {

    }

    global class InputBody{

        public String shop_ord_no { get; set; }
        public String inq_type { get; set; }
        public String inq_name { get; set; }
        public String inq_content { get; set; }
        public String inq_status { get; set; }
        public String inq_time { get; set; }
        public String inq_title { get; set; }
        public String shop_name { get; set; }

    }

    global class OAuth2 {
        
        public String token { get; set; }
    }


}