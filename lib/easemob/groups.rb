module Easemob
  autoload(:GroupMessage, File.expand_path('message/group_message', __dir__))
  module Groups
    def create_group(groupname, desc, is_public, owner,maxusers, members_only, allowinvites, members)
      jd = { 
        groupname: groupname, #群组名称，此属性为必须的
        desc: desc, #群组描述，此属性为必须的
        public: is_public, #是否是公开群，此属性为必须的
        owner: owner #群组的管理员，此属性为必须的
      }
      jd[:maxusers] = maxusers unless maxusers.nil?#群组成员最大数（包括群主），值为数值类型，默认值200，最大值2000，此属性为可选的
      jd[:members_only] = members_only unless members_only.nil? # 加入群是否需要群主或者群管理员审批，默认是false
      jd[:allowinvites] = allowinvites unless allowinvites.nil? #是否允许群成员邀请别人加入此群。 true：允许群成员邀请人加入此群，false：只有群主或者管理员才可以往群里加人。
      jd[:members] = members unless members.nil?#默认添加客服进群。群组成员，此属性为可选的，但是如果加了此项，数组元素至少一个（注：群主jma1不需要写入到members里面）
      GroupMessage.new request :post, 'chatgroups', json: jd
    end

    def get_groups(group_ids)
      GroupMessage.new request :get, "chatgroups/#{[*group_ids].join(',')}"
    end

    def query_groups(limit = 50, cursor: nil)
      params = { limit: limit }
      params[:cursor] = cursor unless cursor.nil?
      GroupMessage.new request :get, 'chatgroups', params: params
    end

    def query_group_users(group_id)
      GroupMessage.new request :get, "chatgroups/#{group_id}/users"
    end

    def query_group_blocks(group_id)
      GroupMessage.new request :get, "chatgroups/#{group_id}/blocks/users"
    end

    def user_joined_chatgroups(username)
      GroupMessage.new request :get, "users/#{username}/joined_chatgroups"
    end

    def delete_group(group_id)
      GroupMessage.new request :delete, "chatgroups/#{group_id}"
    end

    def modify_group(group_id, groupname: nil, description: nil, maxusers: nil, newowner: nil)
      jd = {}
      jd[:groupname] = groupname unless groupname.nil?
      jd[:description] = description unless description.nil?
      jd[:maxusers] = maxusers unless maxusers.nil?
      jd[:newowner] = newowner unless newowner.nil?

      GroupMessage.new request :put, "chatgroups/#{group_id}", json: jd
    end

    def user_join_group(group_id, username)
      GroupMessage.new request :post, "chatgroups/#{group_id}/users/#{username}"
    end

    def user_leave_group(group_id, username)
      GroupMessage.new request :delete, "chatgroups/#{group_id}/users/#{username}"
    end

    def group_add_users(group_id, usernames:)
      GroupMessage.new request :post, "chatgroups/#{group_id}/users", json: { usernames: [*usernames] }
    end

    def group_remove_users(group_id, usernames:)
      GroupMessage.new request :delete, "chatgroups/#{group_id}/users/#{[*usernames].join(',')}"
    end

    def group_set_owner(group_id, newowner)
      GroupMessage.new request :put, "chatgroups/#{group_id}", json: { newowner: newowner }
    end

    def add_to_group_block(group_id, to_block_usernames:)
      GroupMessage.new request :post, "chatgroups/#{group_id}/blocks/users", json: { usernames: [*to_block_usernames] }
    end

    def remove_from_group_block(group_id, blocked_usernames:)
      GroupMessage.new request :delete, "chatgroups/#{group_id}/blocks/users/#{[*blocked_usernames].join(',')}"
    end
  end
end
