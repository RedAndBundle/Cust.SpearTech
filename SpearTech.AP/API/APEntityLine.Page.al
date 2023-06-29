Page 80502 "PTEAP API AP Line"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'apLine';
    EntitySetName = 'apLines';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'ap';
    APIVersion = 'v2.0';
    SourceTable = "PTEAP API AP Line";
    SourceTableTemporary = true;

    // http://bc220-us:7048/bc/api/speartech/ap/v2.0/companies(17bbc8b0-cc08-ee11-8f7b-6045bdc8a215)/apLines?tenant=default&$filter=spearId eq 2381c46b-8d3e-46e5-90e8-9b2a94e40aa9
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                // Lines
                field(claimNumber; Rec."Claim Number") { ApplicationArea = Basic, Suite; }
                field(invoiceType; Rec."Invoice Type") { ApplicationArea = Basic, Suite; }
                field(lineNo; Rec."Line No.") { ApplicationArea = Basic, Suite; }
                field(taskActivity; Rec."Task/Activity") { ApplicationArea = Basic, Suite; }
                field(taskCode; Rec."Task Code") { ApplicationArea = Basic, Suite; }
                field(taskDate; Rec."Task Date") { ApplicationArea = Basic, Suite; }
                field(units; Rec.Units) { ApplicationArea = Basic, Suite; }
                field(rate; Rec.Rate) { ApplicationArea = Basic, Suite; }
                field(amount; Rec.Amount) { ApplicationArea = Basic, Suite; }
                field(description; Rec.Description) { ApplicationArea = Basic, Suite; }
                field(source; Rec.Source) { ApplicationArea = Basic, Suite; }
                field(spearId; Rec."Spear Id") { ApplicationArea = Basic, Suite; }
                field(result; Result) { ApplicationArea = Basic, Suite; }
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Task Code");
        Rec.TestField("Task/Activity");
        Result := Rec.ProcessAPInterface();
    end;

    trigger OnOpenPage()
    begin
        if (Rec.GetFilter("Claim Number") = '') and (Rec.GetFilter("Task/Activity") = '') and (Rec.GetFilter("Spear Id") = '') then
            Error('Please provide a filter on %1, %2, or %3', Rec.FieldCaption("Spear Id"), Rec.FieldCaption("Claim Number"), Rec.FieldCaption("Task/Activity"));

        GetFromSalesLine();
        GetFromSalesInvoiceLine();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Rec.FindSet());
    end;

    local procedure GetFromSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetAutoCalcFields("PTEAP Claim Number");
        if Rec.GetFilter("Spear Id") <> '' then
            SalesLine.SetFilter("PTEAP Spear Id", Rec.GetFilter("Spear Id"));
        if Rec.GetFilter("Claim Number") <> '' then
            SalesLine.SetFilter("PTEAP Claim Number", Rec.GetFilter("Claim Number"));
        if Rec.GetFilter("Task/Activity") <> '' then
            SalesLine.SetFilter("PTEAP Task/Activity", Rec.GetFilter("Task/Activity"));
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindSet() then
            repeat
                Rec."Claim Number" := SalesLine."PTEAP Claim Number";
                Rec."Line No." += 1;
                Rec."Task/Activity" := SalesLine."PTEAP Task/Activity";
                Rec."Task Code" := SalesLine."No.";
                Rec."Task Date" := SalesLine."PTEAP Task Date";
                Rec.Units := SalesLine.Quantity;
                Rec.Rate := SalesLine."Unit Price";
                Rec.Amount := SalesLine."Line Amount";
                Rec.Source := Format(SalesLine.RecordId);
                Rec."Spear Id" := SalesLine."PTEAP Spear Id";
                Rec.Insert();
            until SalesLine.Next() = 0;
    end;

    local procedure GetFromSalesInvoiceLine()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetAutoCalcFields("PTEAP Claim Number");
        if Rec.GetFilter("Spear Id") <> '' then
            SalesInvoiceLine.SetFilter("PTEAP Spear Id", Rec.GetFilter("Spear Id"));
        if Rec.GetFilter("Claim Number") <> '' then
            SalesInvoiceLine.SetFilter("PTEAP Claim Number", Rec.GetFilter("Claim Number"));
        if Rec.GetFilter("Task/Activity") <> '' then
            SalesInvoiceLine.SetFilter("PTEAP Task/Activity", Rec.GetFilter("Task/Activity"));
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);

        if SalesInvoiceLine.FindSet() then
            repeat
                Rec."Claim Number" := SalesInvoiceLine."PTEAP Claim Number";
                Rec."Line No." += 1;
                Rec."Task/Activity" := SalesInvoiceLine."PTEAP Task/Activity";
                Rec."Task Code" := SalesInvoiceLine."No.";
                Rec."Task Date" := SalesInvoiceLine."PTEAP Task Date";
                Rec.Units := SalesInvoiceLine.Quantity;
                Rec.Rate := SalesInvoiceLine."Unit Price";
                Rec.Amount := SalesInvoiceLine."Line Amount";
                Rec."Spear Id" := SalesInvoiceLine."PTEAP Spear Id";
                Rec.Source := Format(SalesInvoiceLine.RecordId);
                Rec."Spear Id" := SalesInvoiceLine."PTEAP Spear Id";
                Rec.Insert();
            until SalesInvoiceLine.Next() = 0;
    end;
}
