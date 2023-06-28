table 80500 "PTEAP API AP Header"
{
    DataClassification = CustomerContent;
    Caption = 'API AP Header';
    TableType = Temporary;

    fields
    {
        field(1; "Claim Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim Number';
        }
        field(2; "Invoice Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Type';
        }
        field(3; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(4; "Bill-To Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(5; "Claimant Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claimant Name';
        }
        field(6; "SSN"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'SSN';
        }
        field(7; "DOB"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'DOB';
        }
        field(8; "Claims Manager"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Claims Manager';
        }
        field(9; "Referral Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Referral Date';
        }
        field(10; "Accident Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Accident Date';
        }
    }

    keys
    {
        key(Key1; "Claim Number", "Invoice Type")
        {
            Clustered = true;
        }
    }

    internal procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        CreatedLbl: Label '%1 %2 Created', Comment = '%1 = doc type %2 = doc no';
    begin
        SalesHeader.PTEAPGetSalesHeader("Sales Document Type"::Invoice, Rec);
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
        SalesHeader: Record "Sales Header";
    begin
        DeleteAll();
        SalesHeader.GetBySystemId(NewSystemId);
        SystemId := SalesHeader.SystemId;
        "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        "Bill-To Customer No." := SalesHeader."Bill-to Customer No.";
        "Claim Number" := SalesHeader."PTEAP Claim Number";
        "Claimant Name" := SalesHeader."PTEAP Claimant Name";
        SSN := SalesHeader."PTEAP SSN";
        DOB := SalesHeader."PTEAP DOB";
        "Claims Manager" := SalesHeader."PTEAP Claims Manager";
        "Referral Date" := SalesHeader."PTEAP Referral Date";
        "Invoice Type" := SalesHeader."PTEAP Invoice Type";
        "Accident Date" := SalesHeader."PTEAP Accident Date";
        exit(Insert());
    end;
}