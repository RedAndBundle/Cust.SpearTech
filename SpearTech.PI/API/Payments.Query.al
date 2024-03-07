query 80600 "PTEPI Payments"
{
    QueryType = API;
    EntityName = 'piPayment';
    EntitySetName = 'piPayments';
    APIPublisher = 'speartech';
    APIGroup = 'pi';
    APIVersion = 'v2.0';

    elements
    {
        dataitem(PaymentCustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = "Document Type" = const("Payment"), "Applies-to Doc. Type" = const("Invoice");
            column(entryNo; "Entry No.") { }
            column(postingDate; "Posting Date") { }
            column(brokerNo; "Customer No.") { }
            column(amount; "Credit Amount") { }
            column(remainingAmount; "Remaining Amount") { }
            dataitem(OriginalCustLedgerEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Closed by Entry No." = PaymentCustLedgerEntry."Entry No.";
                column(documentNo; "Document No.") { }
                dataitem(Sales_Invoice_Header; "Sales Invoice Header")
                {
                    DataItemLink = "No." = OriginalCustLedgerEntry."Document No.";
                    column(claimNumber; "PTEPI Policy Number") { }
                    column(spearNo; "PTEPI Spear No.") { }
                    column(insuredNo; "Sell-to Customer No.") { }
                }
            }
        }
    }
}