tableextension 80502 "PTEAP Sales Shipment  Header" extends "Sales Shipment Header"
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
}