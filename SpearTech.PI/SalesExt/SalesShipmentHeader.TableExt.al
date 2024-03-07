tableextension 80602 "PTEPI Sales Shipment  Header" extends "Sales Shipment Header"
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
}