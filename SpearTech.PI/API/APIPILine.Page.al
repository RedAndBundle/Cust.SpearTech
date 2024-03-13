Page 80602 "PTEPI API PI Line"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'piLine';
    EntitySetName = 'piLines';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'pi';
    APIVersion = 'v2.0';
    SourceTable = "PTEPI API PI Line";
    SourceTableTemporary = true;

    // http://bc230-us:7048/bc/api/speartech/pi/v2.0/companies(43a32486-b6d6-ee11-9051-6045bdc89dc0)/piLines?tenant=default&$filter=spearId eq 2381c46b-8d3e-46e5-90e8-9b2a94e40aa9
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                // Lines
                field(policyNumber; Rec."Policy Number") { ApplicationArea = Basic, Suite; }
                field(spearNo; Rec."Spear No.") { ApplicationArea = Basic, Suite; }
                field(lineNo; Rec."Line No.") { ApplicationArea = Basic, Suite; }
                field(code; Rec."Code") { ApplicationArea = Basic, Suite; }
                field(units; Rec.Units) { ApplicationArea = Basic, Suite; }
                field(rate; Rec.Rate) { ApplicationArea = Basic, Suite; }
                field(amount; Rec.Amount) { ApplicationArea = Basic, Suite; }
                field(description; Rec.Description) { ApplicationArea = Basic, Suite; }
                field(source; Rec.Source) { ApplicationArea = Basic, Suite; }
                field(sourceNo; Rec."Source No.") { ApplicationArea = Basic, Suite; }
                field(sourceLineNo; Rec."Source Line No.") { ApplicationArea = Basic, Suite; }
                field(sourceId; Rec."Source Id") { ApplicationArea = Basic, Suite; }
                field(result; Result) { ApplicationArea = Basic, Suite; }
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Code");
        Result := Rec.ProcessAPInterface();
    end;

    trigger OnOpenPage()
    begin
        if (Rec.GetFilter("Policy Number") = '') and (Rec.GetFilter("Spear No.") = '') and (Rec.GetFilter("Line No.") = '') then
            Error('Please provide a filter on %1, %2, or %3', Rec.FieldCaption("Spear No."), Rec.FieldCaption("Policy Number"), Rec.FieldCaption("Line No."));

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
        SalesLine.SetAutoCalcFields("PTEPI Policy Number");
        if Rec.GetFilter("Spear No.") <> '' then
            SalesLine.SetFilter("PTEPI Spear No.", Rec.GetFilter("Spear No."));
        if Rec.GetFilter("Policy Number") <> '' then
            SalesLine.SetFilter("PTEPI Policy Number", Rec.GetFilter("Policy Number"));
        if Rec.GetFilter("Line No.") <> '' then
            SalesLine.SetFilter("Line No.", Rec.GetFilter("Line No."));
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindSet() then
            repeat
                Rec."Policy Number" := SalesLine."PTEPI Policy Number";
                Rec."Line No." := SalesLine."Line No.";
                Rec."Code" := SalesLine."No.";
                Rec.Units := SalesLine.Quantity;
                Rec.Rate := SalesLine."Unit Price";
                Rec.Amount := SalesLine."Line Amount";
                Rec.Source := Format(SalesLine.RecordId);
                Rec."Source No." := SalesLine."Document No.";
                Rec."Source Line No." := SalesLine."Line No.";
                Rec."Source Id" := SalesLine.SystemId;
                Rec."Spear No." := SalesLine."PTEPI Spear No.";
                Rec.Insert();
            until SalesLine.Next() = 0;
    end;

    local procedure GetFromSalesInvoiceLine()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetAutoCalcFields("PTEPI Policy Number");
        if Rec.GetFilter("Spear No.") <> '' then
            SalesInvoiceLine.SetFilter("PTEPI Spear No.", Rec.GetFilter("Spear No."));
        if Rec.GetFilter("Policy Number") <> '' then
            SalesInvoiceLine.SetFilter("PTEPI Policy Number", Rec.GetFilter("Policy Number"));
        if Rec.GetFilter("Line No.") <> '' then
            SalesInvoiceLine.SetFilter("Line No.", Rec.GetFilter("Line No."));
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);

        if SalesInvoiceLine.FindSet() then
            repeat
                Rec."Policy Number" := SalesInvoiceLine."PTEPI Policy Number";
                Rec."Line No." := SalesInvoiceLine."Line No.";
                Rec."Code" := SalesInvoiceLine."No.";
                Rec.Units := SalesInvoiceLine.Quantity;
                Rec.Rate := SalesInvoiceLine."Unit Price";
                Rec.Amount := SalesInvoiceLine."Line Amount";
                Rec.Source := Format(SalesInvoiceLine.RecordId);
                Rec."Source No." := SalesInvoiceLine."Document No.";
                Rec."Source Line No." := SalesInvoiceLine."Line No.";
                Rec."Source Id" := SalesInvoiceLine.SystemId;
                Rec."Spear No." := SalesInvoiceLine."PTEPI Spear No.";
                Rec.Insert();
            until SalesInvoiceLine.Next() = 0;
    end;
}
