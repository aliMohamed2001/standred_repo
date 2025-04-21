
class Endpoint {
  Endpoint._();

  static const apiBaseUrl = 'https://sys.g-rayan.com/';
  static const loginEndPoint = 'api/auth/login';
  static const logoutEndPoint = 'api/auth/logout';
  static const sendOtpEndPoint = 'api/auth/send_otp';
  static const verifyOtpEndPoint = 'api/auth/verify_otp';
  static const changePasswordEndPoint = 'api/auth/change-password';
  static const inventoryEndPoint = 'api/products/inventory';
  static const customersEndPoint = 'api/customers';
  static const getAllCustomersEndPoint = 'api/customers/count';
  static const getAllInvoicesEndPoint = 'api/invoices/sum';
  static const addCustomerEndPoint = 'api/customer/add';
  static const getAllAreasEndPoint = 'api/areas';
  static const invoiceEndPoint = 'api/invoices';
  static const searchCustomerEndPoint = 'api/customer/search?';
  static const searchInvoiceEndPoint = 'api/invoice/search?';
  static const searchInventoryEndPoint = 'api/products/inventory/search?';
  static const carLoadEndPoint = 'api/products/car';
  static const carLoadSearchEndPoint = 'api/products/car/search?';
  static const addNewInvoice = "api/invoice/add";
  static const getInvoiceDetailsEndPoint = 'api/invoice/get';
  static const editInvoiceEndPoint = 'api/invoice/edit';
  static const cancelInvoiceEndPoint = 'api/invoice/cancel';
  static const confirmInvoiceEndPoint = 'api/invoice/confirm';
  static const addPaymentEndPoint = 'api/invoice/add/payment';
  static const getUserDataEndPoint = 'api/auth/get-details';
  static const sandEndPoint = 'api/payments/add/rf';
  static const getsandEndPoint = 'api/user/payments';
  static const totaloutstandingPaymentsEndPoint = 'api/sales/total_outstanding';
  static const searchsandEndPoint = 'api/user/payments/search?';
  static const changeUserDataEndPoint = 'api/auth/change-details';
  static const connectionTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);
}
