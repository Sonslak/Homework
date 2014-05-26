using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;

namespace ChatApp.Code
{
    public class ChatHelper
    {
        public const string ChatsCacheID = "7d74221b-93e2-4b4c-9cc5-f15459917ac4";
        public const string ChattersCacheID = "bb954f60-7847-4f25-a4d7-d64cce7a77bc";
        private Object ChatLock = new Object();
        private Object ChattersLock = new Object();

        public List<Chatter> Chatters
        {
            get
            {
                List<Chatter> listings = HttpRuntime.Cache.Get(ChattersCacheID) as List<Chatter>;
                if (listings == null)
                {
                    listings = new List<Chatter>();
                    HttpContext.Current.Cache.Insert(ChattersCacheID, listings, null, DateTime.MaxValue , new TimeSpan(1, 00, 0));
                }
                return listings;
            }
            set
            {
                HttpContext.Current.Cache.Insert(ChattersCacheID, value, null, DateTime.MaxValue, new TimeSpan(1, 00, 0));
            }
        }

        public List<Chat> Chats
        {
            get {
                List<Chat> listings = HttpRuntime.Cache.Get(ChatsCacheID) as List<Chat>;
                if (listings == null)  
                {
                    listings = new List<Chat>();
                    HttpContext.Current.Cache.Insert(ChatsCacheID, listings, null, DateTime.MaxValue, new TimeSpan(1, 00, 0));
                }
                return listings;
            }
            set
            {
                HttpContext.Current.Cache.Insert(ChatsCacheID, value, null, DateTime.MaxValue, new TimeSpan(1, 00, 0));
            }
        }

        public void AddMessage(string userName, string message, string sessionId)
        {
            lock (ChatLock)
            {

                Chatters.Where(o => o.UniqueID == sessionId).FirstOrDefault().LastActive = DateTime.Now;
                Chats.Add(new Chat(userName, message));
            }
        }

        public void AddChatter(string userName, string sessionId)
        {
            lock (ChattersLock)
            {
                Chatters.Add(new Chatter(sessionId, userName));
            }
        }    
    }

    public class Chatter
    {
        public string UniqueID { get; set; }
        public string Username { get; set; }
        public DateTime LastActive { get; set; }

        public  Boolean IsAway {
            get
            {
                TimeSpan ts = DateTime.Now - LastActive;
                return ts.TotalMinutes > 15;
            }
        }

        public Chatter(string uniqueId, string userName)
        {
            Username = userName;
            UniqueID = uniqueId;
            LastActive = DateTime.Now;
        }


    }
   
    public class Chat
    {
        public string Username { get; set; }
        public string Message { get; set; }
        public DateTime DateAdded { get; set; }

        public  Chat(string userName, string message)
        {
            Username = userName;
            Message = message;
            DateAdded = DateTime.Now;
        }
    }


}


