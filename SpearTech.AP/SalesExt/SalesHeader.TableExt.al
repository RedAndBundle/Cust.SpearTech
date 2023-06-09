tableextension 80500 "PTEAP Sales Header" extends "Sales Header"
{
    fields
    {
        field(80500; "PTEAP Claim Number"; Text[100])
        {
            DataClassification = SystemMetadata;
            Caption = 'Claim Number';
        }
        field(80501; "PTEAP Claimant Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claimant Name';
        }
        field(80502; "PTEAP SSN"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'SSN';
        }
        field(80503; "PTEAP DOB"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'DOB';
        }
        field(80504; "PTEAP Claims Manager"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claims Manager';
        }
        field(80505; "PTEAP Referral Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Referral Date';
        }
        field(80506; "PTEAP Invoice Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Type';
        }
        field(80507; "PTEAP Accident Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Accident Date';
        }
    }

    internal procedure PTEAPGetSalesHeader(DocumentType: Enum "Sales Document Type"; var APIAPHeader: Record "PTEAP API AP Header"): Boolean;
    begin
        if PTEAPGetSalesHeader(DocumentType, APIAPHeader."Claim Number", APIAPHeader."Invoice Type") then
            exit(true);

        Init();
        "Document Type" := DocumentType;
        Validate("Sell-to Customer No.", APIAPHeader."Sell-to Customer No.");
        if (APIAPHeader."Bill-To Customer No." <> '') and (APIAPHeader."Bill-To Customer No." <> APIAPHeader."Sell-to Customer No.") then
            Validate("Bill-to Customer No.", APIAPHeader."Bill-To Customer No.");

        "PTEAP Claim Number" := APIAPHeader."Claim Number";
        "PTEAP Claimant Name" := APIAPHeader."Claimant Name";
        "PTEAP SSN" := APIAPHeader.SSN;
        "PTEAP DOB" := APIAPHeader.DOB;
        "PTEAP Claims Manager" := APIAPHeader."Claims Manager";
        "PTEAP Referral Date" := APIAPHeader."Referral Date";
        "PTEAP Invoice Type" := APIAPHeader."Invoice Type";
        Insert(true);
        exit(true);
    end;

    internal procedure PTEAPGetSalesHeader(DocumentType: Enum "Sales Document Type"; ClaimNumber: Text; InvoiceType: Text): Boolean;
    begin
        SetRange("PTEAP Claim Number", ClaimNumber);
        SetRange("PTEAP Invoice Type", InvoiceType);
        SetRange("Document Type", DocumentType);
        exit(FindLast());
    end;
}