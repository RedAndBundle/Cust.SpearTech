tableextension 80401 "PTE Check Arguments" extends "ForNAV Check Arguments"
{
    fields
    {
        field(80400; "PTE Document No."; Code[20]) { DataClassification = SystemMetadata; }
        field(80401; "PTE Output Type"; Option)
        {
            OptionMembers = "Print","PDF";
            OptionCaption = 'Print,PDF';
            DataClassification = SystemMetadata;
        }
    }

}