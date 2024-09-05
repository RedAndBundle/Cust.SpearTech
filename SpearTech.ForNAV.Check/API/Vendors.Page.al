page 80404 "PTE Vendors"
{
    DelayedInsert = true;
    // DeleteAllowed = false;
    // InsertAllowed = false;
    // ModifyAllowed = false;
    EntityName = 'vendor';
    EntitySetName = 'vendors';
    ODataKeyFields = "No.";
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = Vendor;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(name2; Rec."Name 2")
                {
                    ApplicationArea = all;
                }
                field(address; Rec.Address)
                {
                    ApplicationArea = all;
                }
                field(address2; Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field(city; Rec.City)
                {
                    ApplicationArea = all;
                }
                field(county; Rec.County)
                {
                    ApplicationArea = all;
                }
                field(postCode; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
#if not dev
                field(federalIDNo; Rec."Federal ID No.")
                {
                    ApplicationArea = all;
                }
#endif
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    ApplicationArea = all;
                }
                field(combinePayments; Rec."PTE Combine Payments")
                {
                    ApplicationArea = all;
                }
                field(id; Rec.SystemId)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
