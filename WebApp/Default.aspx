<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApp.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Email validation prototype website</title>
</head>
<body>
    <form id="form1" runat="server">
        
        <script type="text/javascript">

            var checkedValues = {};

            function UnusedEmailValidation(sender, args) {

                //oproti defaultnimu chovani ignorujeme mezery za emailem
                var value = args.Value.trim();

                //dotaz na server posilame jen v pripade, kdyz se jedna o validni format emailu (resp. kdyz jsou validni vsechny predchazejici validatory pro stejne pole - je tam i regexp)
                if (CustomValidatorShouldBeChecked(sender)) {

                    if (checkedValues[value] === undefined) {

                        //zatim kontrola neprobehla, takze se muzeme asynchronne dotazat serveru
                        checkedValues[value] = null;

                        $.ajax({
                            type: "POST", contentType: "application/json", dataType: "json",
                            url: "Default.aspx/UnusedEmailValidation",
                            data: '{"email":"' + value + '"}',
                            success: function (result) {

                                checkedValues[value] = result.d;

                                //revalidovat, kdyz uz zname vysledek ... evt. pro reuse jen ValidatorValidate(sender);
                                Page_ClientValidate();

                            }
                        });


                    } else if (checkedValues[value] !== null) {

                        //zname uz vysledek, neptame se znovu 
                        args.IsValid = checkedValues[value];

                    } else {

                        //jeste neskoncilo predchozi zjistovani stavu, v teto fazi to na klientu optimisticky povazujeme za validni, at pripadna network chyba neomezi odeslani formulare
                        //nevalidni vstup v takovem pripade kontroluje server a nasleduje postback
                        args.IsValid = true;

                    }

                }
                else {

                    //do te doby povazujeme za validni
                    args.IsValid = true;

                }
            }

                    //help na kontrolu, zda jsou ostatni validatory ok
            function CustomValidatorShouldBeChecked(sender) {

                if (typeof Page_Validators == 'object') {
                    for (var i in Page_Validators) {
                        if (Page_Validators[i].controltovalidate === sender.controltovalidate && Page_Validators[i].id !== sender.id) {
                            if (!Page_Validators[i].isvalid)
                                return false;
                        }
                    }
                }

                return true;
            }

                    //chceme(?) to validovat na keypress jeste pred blur? .. pri jednom fieldu a jednom tlacitku to ma smysl
            function OnKeyValidate() {

                if (this.timer)
                    clearTimeout(this.timer);

                this.timer = setTimeout(function () {

                    if (typeof (Page_ClientValidate) == 'function')
                        Page_ClientValidate();

                }, 500);
            }

        </script>

        <div>

            [ <a href='Default.aspx'>DEBUG</a> [ lastpostback=<%= DateTime.Now.ToLongTimeString() %>, dbrows=<%= DebugCount() %> ]<br /><br />


            <asp:TextBox ID="TextEmail" runat="server" onkeyup="OnKeyValidate();" autocomplete="off" AutoCompleteType="Disabled"></asp:TextBox>

            <asp:RequiredFieldValidator ControlToValidate="TextEmail" runat="server" ErrorMessage="Missing" ForeColor="Red" Display="Dynamic" ></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ControlToValidate="TextEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\s*" runat="server" ErrorMessage="Invalid" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
            <asp:CustomValidator ControlToValidate="TextEmail" ClientValidationFunction="UnusedEmailValidation" OnServerValidate="ValidUnused_ServerValidate" runat="server" ErrorMessage="Already used" ForeColor="Red" Display="Dynamic"></asp:CustomValidator>

            <br />

            <asp:Button ID="BtnSubmit" runat="server" Text="Next" OnClick="BtnSubmit_Click" CausesValidation="true" />
            <br />

        </div>
    </form>
</body>
</html>

