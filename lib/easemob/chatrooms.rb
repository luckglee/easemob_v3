module Easemob
  module Chatrooms
    def create_chatroom(chatroom_name, description, owner, maxusers: 200, members: nil)
      jd = { name: chatroom_name, description: description, owner: owner, maxusers: maxusers }
      jd[:members] = members unless members.nil?
      request :post, 'chatrooms', json: jd
    end

    def get_chatroom(chatroom_id)
      request :get, "chatrooms/#{chatroom_id}"
    end

    def query_chatrooms
      request :get, 'chatrooms'
    end

    def user_joined_chatrooms(username)
      request :get, "users/#{username}/joined_chatrooms"
    end

    def delete_chatroom(chatroom_id)
      request :delete, "chatrooms/#{chatroom_id}"
    end

    def modify_chatroom(chatroom_id, chatroom_name: nil, description: nil, maxusers: nil)
      jd = {}
      jd[:name] = chatroom_name unless chatroom_name.nil?
      jd[:description] = description unless description.nil?
      jd[:maxusers] = maxusers unless maxusers.nil?
      request :put, "chatrooms/#{chatroom_id}", json: jd
    end

    def user_join_chatroom(chatroom_id, username:)
      request :post, "chatrooms/#{chatroom_id}/users/#{username}"
    end

    def user_leave_chatroom(chatroom_id, username:)
      request :delete, "chatrooms/#{chatroom_id}/users/#{username}"
    end

    def chatroom_add_users(chatroom_id, usernames:)
      request :post, "chatrooms/#{chatroom_id}/users", json: { usernames: [*usernames] }
    end

    def chatroom_remove_users(chatroom_id, usernames:)
      request :delete, "chatrooms/#{chatroom_id}/users/#{[*usernames].join(',')}"
    end
  end
end
