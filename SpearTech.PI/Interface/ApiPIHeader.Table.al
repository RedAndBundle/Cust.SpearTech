table 80600 "PTEPI API PI Header"
{
    DataClassification = CustomerContent;
    Caption = 'API PI Header';
    TableType = Temporary;

    fields
    {
        field(1; "Invoice Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Date';
        }
        field(2; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice No.';
        }
        field(3; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            TableRelation = Customer;
        }
        field(4; "Broker No."; Code[20])
        {
            Caption = 'Broker No.';
            TableRelation = Customer;
        }
        field(5; "Payments Received"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Payments Received';
        }
        field(6; "Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance';
        }
        field(7; "Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear No.';
        }
        field(8; "Policy Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Number';
        }
        field(9; "Policy Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Effective Date';
        }
        field(10; "Policy Expiration Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Expiration Date';
        }
        field(11; "Policy Type"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Type';
        }
        field(12; "Payment Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Due Date';
        }
        field(13; "Policy Total Premium"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Premium';
        }
        field(14; "Policy Total Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Charges';
        }
        field(15; "Policy Total Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Cost';
        }
    }

    keys
    {
        key(Key1; "Policy Number", "Spear No.")
        {
            Clustered = true;
        }
    }

    internal procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        CreatedLbl: Label '%1 %2 Created', Comment = '%1 = doc type %2 = doc no';
    begin
        SalesHeader.PTEPIGetSalesHeader("Sales Document Type"::Invoice, Rec);
        SystemId := SalesHeader.SystemId;
        exit(StrSubstNo(CreatedLbl, SalesHeader."Document Type", SalesHeader."No."));
    end;

    internal procedure Post()
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        if not SalesHeader.GetBySystemId(SystemId) then
            exit;

        SalesPost.SetSuppressCommit(true);
        SalesPost.Run(SalesHeader);
    end;

    internal procedure GetFromSystemId(NewSystemId: Guid): Boolean
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        DeleteAll();
        SalesHeader.GetBySystemId(NewSystemId);
        Customer.Get(SalesHeader."Bill-to Customer No.");
        Customer.CalcFields(Balance, Payments);
        SystemId := SalesHeader.SystemId;

        "Invoice Date" := SalesHeader."Document Date";
        "Invoice No." := SalesHeader."No.";
        "Insured No." := SalesHeader."Sell-to Customer No.";
        "Broker No." := SalesHeader."Bill-to Customer No.";
        "Payments Received" := Customer.Payments;
        "Balance" := Customer.Balance;
        "Spear No." := SalesHeader."PTEPI Spear No.";
        "Policy Number" := SalesHeader."PTEPI Policy Number";
        "Policy Effective Date" := SalesHeader."PTEPI Policy Effective Date";
        "Policy Expiration Date" := SalesHeader."PTEPI Policy Expiration Date";
        "Policy Type" := SalesHeader."PTEPI Policy Type";
        "Payment Due Date" := SalesHeader."PTEPI Payment Due Date";
        "Policy Total Premium" := SalesHeader."PTEPI Policy Total Premium";
        "Policy Total Charges" := SalesHeader."PTEPI Policy Total Charges";
        "Policy Total Cost" := SalesHeader."PTEPI Policy Total Cost";

        exit(Insert());

        // SalesHeader."PTEPI Spear No."
        // SalesHeader."PTEPI Policy Number"
        // SalesHeader."PTEPI Policy Effective Date"
        // SalesHeader."PTEPI Policy Expiration Date"
        // SalesHeader."PTEPI Policy Type"
        // SalesHeader."PTEPI Payment Due Date"
        // SalesHeader."PTEPI Policy Total Premium"
        // SalesHeader."PTEPI Policy Total Charges"
        // SalesHeader."PTEPI Policy Total Cost"

        // "Invoice Date"
        // "Invoice No."
        // "Insured No."
        // "Broker No."
        // "Payments Received"
        // "Balance"
        // "Spear No."
        // "Policy Number"
        // "Policy Effective Date"
        // "Policy Expiration Date"
        // "Policy Type"
        // "Payment Due Date"
        // "Policy Total Premium"
        // "Policy Total Charges"
        // "Policy Total Cost"
    end;
}