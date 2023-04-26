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
    }

    // keys
    // {
    //     key(PTEClaimNumber; "PTEAP Claim Number") { }
    // }

    internal procedure PTEGetSalesHeader(DocumentType: Enum "Sales Document Type"; var APIAPHeader: Record "PTEAP API AP Header"): Boolean;
    var
        SalesHeader: Record "Sales Header";
    begin
        if PTEGetSalesHeader(DocumentType, APIAPHeader."Claim Number") then
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
        Insert(true);
        exit(true);
    end;

    internal procedure PTEGetSalesHeader(DocumentType: Enum "Sales Document Type"; ClaimNumber: Text): Boolean;
    var
        SalesHeader: Record "Sales Header";
    begin
        SetRange("PTEAP Claim Number", ClaimNumber);
        SetRange("Document Type", DocumentType);
        if FindLast() then
            exit(true);
    end;
}