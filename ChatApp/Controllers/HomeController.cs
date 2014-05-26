using System;

using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ChatApp.Code;
using ChatApp.Models;

namespace ChatApp.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/

        public ActionResult Index()
        {                    
            if (System.Web.HttpContext.Current.Session["username"] != null)
            {
                ChatHelper helper = new ChatHelper();        
                ChatModel model = new ChatModel();
                model.Chats = helper.Chats.Take(500).ToList();
                model.Chatters = helper.Chatters;
                model.Username = System.Web.HttpContext.Current.Session["username"].ToString();
                return View(model);
            }
            else
            {
                return View("Login");
            }
        }

        public ActionResult AddChat(string message)
        {
            if (System.Web.HttpContext.Current.Session["username"] != null)
            {
                ChatHelper helper = new ChatHelper();
                string username = (string)System.Web.HttpContext.Current.Session["username"];
                helper.AddMessage(username, message,System.Web.HttpContext.Current.Session.SessionID);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Login(FormCollection form)
        {
            if (form["Username"] != null)
            {
                System.Web.HttpContext.Current.Session["username"] = form["Username"];
                ChatHelper helper = new ChatHelper();
                helper.AddChatter((string)System.Web.HttpContext.Current.Session["username"], System.Web.HttpContext.Current.Session.SessionID);
                return RedirectToAction("Index");
            }

            return View();
        }

        public ActionResult Logout()
        {
            System.Web.HttpContext.Current.Session["username"] = null;
            return RedirectToAction("Index");
        }
    }
}
