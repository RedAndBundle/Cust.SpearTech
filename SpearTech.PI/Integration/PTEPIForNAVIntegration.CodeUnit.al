codeunit 80600 "PTEPI ForNAV Integration"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ForNAV TempTable", 'OnFillTemporaryTable', '', false, false)]
    local procedure OnFillTemporaryTable(ChildDataItemId: Text; ParentRecRef: RecordRef; ReportID: Integer; var IsHandled: Boolean; var TempRecRef: RecordRef)
    begin
        case TempRecRef.Number of
            DataBase::Customer:
                IsHandled := GetCustomer(ParentRecRef, TempRecRef);
        end;
    end;

    local procedure GetCustomer(ParentRecRef: RecordRef; TempRecRef: RecordRef): Boolean
    var
        Customer: Record "Customer";
        TempCustomer: Record Customer temporary;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        TempRecRef.SetTable(TempCustomer);
        TempCustomer.DeleteAll();
        case ParentRecRef.Number of
            DataBase::"Sales Header":
                begin
                    ParentRecRef.SetTable(SalesHeader);
                    Customer.Get(SalesHeader."Sell-to Customer No.");
                    TempCustomer := Customer;
                    TempCustomer.Insert();
                    TempCustomer.SetRange("Date Filter", SalesHeader."PTEPI Policy Effective Date", WorkDate());
                    // TempCustomer.SetFilter("Date Filter", '..%1', WorkDate());
                end;
            DataBase::"Sales Invoice Header":
                begin
                    ParentRecRef.SetTable(SalesInvoiceHeader);
                    Customer.Get(SalesInvoiceHeader."Sell-to Customer No.");
                    TempCustomer := Customer;
                    TempCustomer.Insert();
                    TempCustomer.SetRange("Date Filter", SalesInvoiceHeader."PTEPI Policy Effective Date", WorkDate());
                    // TempCustomer.SetFilter("Date Filter", '..%1', WorkDate());
                end;
        end;

        TempRecRef.Copy(TempCustomer, true);
        exit(true);
    end;
}