query 80500 "PTEAP Payments"
{
    QueryType = API;
    EntityName = 'apPayment';
    EntitySetName = 'apPayments';
    APIPublisher = 'speartech';
    APIGroup = 'ap';
    APIVersion = 'v2.0';

    elements
    {
        dataitem(PaymentCustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = "Document Type" = const("Payment"), "Applies-to Doc. Type" = const("Invoice");
            column(entryNo; "Entry No.") { }
            column(postingDate; "Posting Date") { }
            column(customerNo; "Customer No.") { }
            dataitem(OriginalCustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Entry No." = PaymentCustLedgerEntry."Closed by Entry No.";
                column(documentNo; "Document No.") { }
            }
        }
    }
}