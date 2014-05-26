using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ChatApp.Code;

namespace ChatApp.Models
{
    public class ChatModel
    {
        public string Username { get; set; } 
        public List<Chatter> Chatters{ get; set; }
        public List<Chat> Chats { get; set; } 
    }
}