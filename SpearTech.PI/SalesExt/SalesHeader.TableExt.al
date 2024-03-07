tableextension 80600 "PTEPI Sales Header" extends "Sales Header"
{
    fields
    {
        field(80600; "PTEPI Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear No.';
        }
        field(80601; "PTEPI Policy Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Number';
        }
        field(80602; "PTEPI Policy Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Effective Date';
        }
        field(80603; "PTEPI Policy Expiration Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Expiration Date';
        }
        field(80604; "PTEPI Policy Type"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Type';
        }
        field(80605; "PTEPI Payment Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Due Date';
        }
        field(80606; "PTEPI Policy Total Premium"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Premium';
        }
        field(80607; "PTEPI Policy Total Charges"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Charges';
        }
        field(80608; "PTEPI Policy Total Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Total Cost';
        }
    }

    internal procedure PTEPIGetSalesHeader(DocumentType: Enum "Sales Document Type"; var APIAPHeader: Record "PTEPI API PI Header"): Boolean;
    begin
        if PTEPIGetSalesHeader(DocumentType, APIAPHeader."Policy Number", APIAPHeader."Spear No.") then
            exit(true);

        Init();
        "Document Type" := DocumentType;
        Validate("Sell-to Customer No.", APIAPHeader."Insured No.");
        if (APIAPHeader."Broker No." <> '') and (APIAPHeader."Broker No." <> APIAPHeader."Insured No.") then
            Validate("Bill-to Customer No.", APIAPHeader."Broker No.");

        "PTEPI Spear No." := APIAPHeader."Spear No.";
        "PTEPI Policy Number" := APIAPHeader."Policy Number";
        "PTEPI Policy Effective Date" := APIAPHeader."Policy Effective Date";
        "PTEPI Policy Expiration Date" := APIAPHeader."Policy Expiration Date";
        "PTEPI Policy Type" := APIAPHeader."Policy Type";
        "PTEPI Payment Due Date" := APIAPHeader."Payment Due Date";
        "PTEPI Policy Total Premium" := APIAPHeader."Policy Total Premium";
        "PTEPI Policy Total Charges" := APIAPHeader."Policy Total Charges";
        "PTEPI Policy Total Cost" := APIAPHeader."Policy Total Cost";
        Insert(true);
        exit(true);
    end;

    internal procedure PTEPIGetSalesHeader(DocumentType: Enum "Sales Document Type"; ClaimNumber: Text; InvoiceType: Text): Boolean;
    begin
        SetRange("PTEPI Policy Number", ClaimNumber);
        SetRange("PTEPI Spear No.", InvoiceType);
        SetRange("Document Type", DocumentType);
        exit(FindLast());
    end;
}