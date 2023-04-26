tableextension 80503 "PTEAP Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(80500; "PTEAP Task/Activity"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Task/Activity';
        }
        field(80501; "PTEAP Task Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Task Date';
        }
    }
}