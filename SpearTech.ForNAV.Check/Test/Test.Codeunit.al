codeunit 50149 "PTE Test Interface"
{
    Subtype = Test;

    [Test]
    procedure TestInterface()
    var
        PaymentInterface: Record "PTE Payment Interface";
        GLEntry: Record "G/L Entry";
        VendLedEnt: Record "Vendor Ledger Entry";
        PDFFile: Record "ForNAV File Storage";
        is: InStream;
        Base64Conv: Codeunit "Base64 Convert";
        Base64Text: Text;
    begin
        PaymentInterface."Vendor No." := '10000';
        PaymentInterface."Document No." := 'TEST01';
        PaymentInterface."External Document No." := 'EXTTEST01';
        PaymentInterface."Amount (USD)" := 100;
        PaymentInterface.Description := 'Payment Description';
        PaymentInterface.ProcessPaymentInterface(GetSampleBase64PDF());

        GLEntry.SetRange("Document No.", PaymentInterface."Document No.");
        GLEntry.SetRange(Amount, PaymentInterface."Amount (USD)");
        GLEntry.FindFirst();
        GLEntry.TestField("External Document No.", PaymentInterface."External Document No.");

        VendLedEnt.SetRange("Document No.", PaymentInterface."Document No.");
        VendLedEnt.FindFirst();
        VendLedEnt.CalcFields("Original Amount");
        VendLedEnt.TestField("Original Amount", PaymentInterface."Amount (USD)");

        PDFFile.Get(PaymentInterface."Document No.");
        PDFFile.CalcFields(Data);
        PDFFile.Data.CreateInStream(is);
        is.ReadText(Base64Text);
        Base64Text := Base64Conv.ToBase64(Base64Text);
        if Base64Text <> GetSampleBase64PDF() then
            Error('Something is wrong with the base64 stuff');

    end;

    local procedure GetSampleBase64PDF(): Text
    begin

        exit('JVBERi0xLjcNCiW1tbW1DQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIvTGFuZyhlbi1VUykgL1N0cnVjdF' +
        'RyZWVSb290IDEwIDAgUi9NYXJrSW5mbzw8L01hcmtlZCB0cnVlPj4vTWV0YWRhdGEgMjAgMCBSL1ZpZXdlclByZWZlcmVuY2VzIDIxIDAgUj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8L1R5cGUvUGFnZXMvQ291bnQgMS9LaWRzWyAzIDAgUl0gPj4NCmVuZG9iag0KMyAwIG9iag0KPDwvVHlwZS9QYWdlL1BhcmVudCAyIDAgUi9SZXNvdXJjZXM8PC9Gb250PDwvRjEgNSAwIFI+Pi9FeHRHU3RhdGU8PC9HUzcgNyAwIFIvR1M4IDggMCBSPj4vUHJvY1NldFsvUERGL1RleHQvSW1hZ2VCL0ltYWdlQy9JbWFnZUldID4+L01lZGlhQm94WyAwIDAgNjEyIDc5Ml0gL0NvbnRlbnRzIDQgMCBSL0dyb3VwPDwvVHlwZS9Hcm91cC9TL1RyYW5zcGFyZW5jeS9DUy9EZXZpY2VSR0I+Pi9UYWJzL1MvU3RydWN0UGFyZW50cyAwPj4NCmVuZG9iag0KNCAwIG9iag0KPDwvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCAxNzE+Pg0Kc3RyZWFtDQp4nKWOzQqCQACE7wv7DnPUwP1L3RbEgz9JoUG40CE6eCgPlZS9P7SJF8/NYWBgmG/A21c3IEl4k+8KCF53Qw9veASH2k9TZEWONyWCiZ+MVBCInWujMF4pOa0wUJJZSvhWQkomQtgbJdL1BCS0YkKF0MKwKIZ9ul7VavQft4l+Sps5VZScvcYP1l433v0L7J6S0g0fKfnngYlYFC4eTOCZhyUIZZPjCy4UNvQNCmVuZHN0cmVhbQ0KZW5kb2JqDQo1IDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0YxL0Jhc2VGb250L0JDREVFRStDYWxpYnJpL0VuY29kaW5nL1dpbkFuc2lFbmNvZGluZy9Gb250RGVzY3JpcHRvciA2IDAgUi9GaXJzdENoYXIgMzIvTGFzdENoYXIgMTE0L1dpZHRocyAxOCAwIFI+Pg0KZW5kb2JqDQo2IDAgb2JqDQo8PC9UeXBlL0ZvbnREZXNjcmlwdG9yL0ZvbnROYW1lL0JDREVFRStDYWxpYnJpL0ZsYWdzIDMyL0l0YWxpY0FuZ2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m9zb2Z0wq4gV29yZCB2b29yIE1pY3Jvc29mdCAzNjU8L3BkZjpQcm9kdWNlcj48L3JkZjpEZXNjcmlwdGlvbj4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyI+CjxkYzpjcmVhdG9yPjxyZGY6U2VxPjxyZGY6bGk+TWFyayBCcnVtbWVsPC9yZGY6bGk+PC9yZGY6U2VxPjwvZGM6Y3JlYXRvcj48L3JkZjpEZXNjcmlwdGlvbj4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+Cjx4bXA6Q3JlYXRvclRvb2w+TWljcm9zb2Z0wq4gV29yZCB2b29yIE1pY3Jvc29mdCAzNjU8L3htcDpDcmVhdG9yVG9vbD48eG1wOkNyZWF0ZURhdGU+MjAyMS0wNi0yNFQxNDowNTowNCswMjowMDwveG1wOkNyZWF0ZURhdGU+PHhtcDpNb2RpZnlEYXRlPjIwMjEtMDYtMjRUMTQ6MDU6MDQrMDI6MDA8L3htcDpNb2RpZnlEYXRlPjwvcmRmOkRlc2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiAgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iPgo8eG1wTU06RG9jdW1lbnRJRD51dWlkOkVFMEI3NDNFLTZGQzktNDM2Ny1BQzc2LUFDNUZDMzE2RkRENDwveG1wTU06RG9jdW1lbnRJRD48eG1wTU06SW5zdGFuY2VJRD51dWlkOkVFMEI3NDNFLTZGQzktNDM2Ny1BQzc2LUFDNUZDMzE2RkRENDwveG1wTU06SW5zdGFuY2VJRD48L3JkZjpEZXNjcmlwdGlvbj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCjwvcmRmOlJERj48L3g6eG1wbWV0YT48P3hwYWNrZXQgZW5kPSJ3Ij8+DQplbmRzdHJlYW0NCmVuZG9iag0KMjEgMCBvYmoNCjw8L0Rpc3BsYXlEb2NUaXRsZSB0cnVlPj4NCmVuZG9iag0KMjIgMCBvYmoNCjw8L1R5cGUvWFJlZi9TaXplIDIyL1dbIDEgNCAyXSAvUm9vdCAxIDAgUi9JbmZvIDkgMCBSL0lEWzwzRTc0MEJFRUM5NkY2NzQzQUM3NkFDNUZDMzE2RkREND48M0U3NDBCRUVDOTZGNjc0M0FDNzZBQzVGQzMxNkZERDQ+XSAvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCA4NT4+DQpzdHJlYW0NCnicLcs7FYBADETRyX6AFldoQMAKwAFnvYAoOJQ4oF7CDClyi+QBPq2Z7xH42MRF7CbhILGStIhdnH5nHkQUSWRh4v/svMsP834lw0RmI6UALxzUC4ANCmVuZHN0cmVhbQ0KZW5kb2JqDQp4cmVmDQowIDIzDQowMDAwMDAwMDEwIDY1NTM1IGYNCjAwMDAwMDAwMTcgMDAwMDAgbg0KMDAwMDAwMDE2NiAwMDAwMCBuDQowMDAwMDAwMjIyIDAwMDAwIG4NCjAwMDAwMDA0ODYgMDAwMDAgbg0KMDAwMDAwMDczMSAwMDAwMCBuDQowMDAwMDAwODk5IDAwMDAwIG4NCjAwMDAwMDExMzggMDAwMDAgbg0KMDAwMDAwMTE5MSAwMDAwMCBuDQowMDAwMDAxMjQ0IDAwMDAwIG4NCjAwMDAwMDAwMTEgNjU1MzUgZg0KMDAwMDAwMDAxMiA2NTUzNSBmDQowMDAwMDAwMDEzIDY1NTM1IGYNCjAwMDAwMDAwMTQgNjU1MzUgZg0KMDAwMDAwMDAxNSA2NTUzNSBmDQowMDAwMDAwMDE2IDY1NTM1IGYNCjAwMDAwMDAwMTcgNjU1MzUgZg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAxOTIxIDAwMDAwIG4NCjAwMDAwMDIxMjAgMDAwMDAgbg0KMDAwMDAyMzA0MSAwMDAwMCBuDQowMDAwMDI2MjE0IDAwMDAwIG4NCjAwMDAwMjYyNTkgMDAwMDAgbg0KdHJhaWxlcg0KPDwvU2l6ZSAyMy9Sb290IDEgMCBSL0luZm8gOSAwIFIvSURbPDNFNzQwQkVFQzk2RjY3NDNBQzc2QUM1RkMzMTZGREQ0PjwzRTc0MEJFRUM5NkY2NzQzQUM3NkFDNUZDMzE2RkREND5dID4+DQpzdGFydHhyZWYNCjI2NTQzDQolJUVPRg0KeHJlZg0KMCAwDQp0cmFpbGVyDQo8PC9TaXplIDIzL1Jvb3QgMSAwIFIvSW5mbyA5IDAgUi9JRFs8M0U3NDBCRUVDOTZGNjc0M0FDNzZBQzVGQzMxNkZERDQ+PDNFNzQwQkVFQzk2RjY3NDNBQzc2QUM1RkMzMTZGREQ0Pl0gL1ByZXYgMjY1NDMvWFJlZlN0bSAyNjI1OT4+DQpzdGFydHhyZWYNCjI3MTU5DQolJUVPRg==');

    end;


}