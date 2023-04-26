table 80501 "PTEAP Spear AP Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[1]) { DataClassification = SystemMetadata; }
        field(10; "Item Template"; Code[20]) { DataClassification = CustomerContent; TableRelation = "Item Templ."; }
    }

    keys { key(pk; "Primary Key") { Clustered = true; } }
}