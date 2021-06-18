table 50100 "PTE Payment Interface"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Vendor No."; Code[20]) { DataClassification = SystemMetadata; }
        field(2; "Document No."; Code[20]) { DataClassification = SystemMetadata; }
        field(3; "Amount (USD)"; Decimal) { DataClassification = SystemMetadata; }
    }

    keys { key(Key1; "Vendor No.") { Clustered = true; } }


}