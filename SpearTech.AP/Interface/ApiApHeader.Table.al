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
    }

    keys
    {
        key(Key1; "Claim Number", "Invoice Type")
        {
            Clustered = true;
        }
    }

    procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        CreatedLbl: Label '%1 %2 Created', Comment = '%1 = doc type %2 = doc no';
    begin
        SalesHeader.PTEAPGetSalesHeader("Sales Document Type"::Invoice, Rec);
        exit(StrSubstNo(CreatedLbl, SalesHeader."Document Type", SalesHeader."No."));
    end;
}