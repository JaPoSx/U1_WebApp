using Dapper;
using System;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApp
{
    public partial class Default : Page
    {
        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                var email = $"{TextEmail.Text}".Trim();
                try
                {
                    using (var db = new DataConnection())
                        db.Session.Execute("INSERT INTO [Customers] ( [Email] ) VALUES ( @email )", new { email });

                    Response.Redirect("~/Final.aspx");
                }
                catch (Exception ex)
                {
                    var script = $"alert('Unexpected error registering this email address ({ex.Message?.Replace("'", "\\'")})');";
                    ScriptManager.RegisterClientScriptBlock(BtnSubmit, this.GetType(), "Fail", script, true);
                }
            }
        }

        [WebMethod]
        public static bool UnusedEmailValidation(string email)
        {
            using (var db = new DataConnection())
            {
                var stored = db.Session.QueryFirstOrDefault<string>("SELECT [Email] FROM [Customers] WHERE [Email]=@email", new { email = email?.Trim() });
                return string.IsNullOrEmpty(stored);
            }
        }

        protected void ValidUnused_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = UnusedEmailValidation(args.Value);
        }

        /// <summary>
        /// zobrazi v debug radku pocet zaznamu v db... je tu taky proto, aby nebyl prvni request do databaze az v ajaxu, chyba v connection stringu ci pripojeni by nebyla hned zjevna ;)
        /// </summary>
        protected string DebugCount()
        {
            using (var db = new DataConnection())
            {
                var count = db.Session.QueryFirst<int>("SELECT COUNT(*) FROM [Customers]");
                return $"{count}";
            }

        }

    }
}