module Easemob
  autoload(:ChatMessage, File.expand_path('message/chat_message', __dir__))
  module Messages

    def message_to(target_type, target, text, from)
      jd = { 
        target_type: target_type, # "users": 给用户发消息。"chatgroups": 给群发消息，"chatrooms": 给聊天室发消息
        target: target, # 接收消息的用户/群。注意这里需要用数组,元素为用户账号/群id
        msg: { 
          type: :txt, 
          msg: text #消息内容
        } 
      }
      jd[:from] = from unless from.nil? #表示消息发送者。无此字段Server会默认设置为"from":"admin"，有from字段但值为空串("")时请求失败
      ChatMessage.new request :post, 'messages', json: jd
    end
	  
    def image_to(target_type,target,url,filename,secret,from,width,height)
				 
		jd = {
			"target_type": target_type,   #users 给用户发消息。chatgroups: 给群发消息，chatrooms: 给聊天室发消息
			"target":target,# 数组，给用户发送时数组元素是用户名，给群组发送时数组元素是groupid
			"msg":{  #消息内容
				"type":"img",   # 消息类型
				"url": url,  #成功上传文件返回的UUID
				"filename": filename, # 指定一个文件名
				"secret": secret, # 成功上传文件后返回的secret
				"size":{
				  "width":width,
				  "height":height
				}
			 },
			"from":from #表示消息发送者，无此字段Server会默认设置为"from":"admin"，有from字段但值为空串("")时请求失败
		}
      ChatMessage.new request :post, 'messages', json: jd
    end

    def audio_to(target, target_type: :users, url:, filename:, length:,
                 secret: nil, from: nil, ext: nil)
      jd = { target_type: target_type, target: [*target],
             msg: { type: :audio, url: url, filename: filename, length: length } }
      jd[:msg][:secret] = secret unless secret.nil?
      jd[:from] = from unless from.nil?
      jd[:ext] = ext unless ext.nil?
      ChatMessage.new request :post, 'messages', json: jd
    end

    def video_to(target, target_type: :users, url:, filename:, length:, file_length:, thumb:,
                 secret: nil, thumb_secret: nil, from: nil, ext: nil)
      jd = { target_type: target_type, target: [*target],
             msg: { type: :video, filename: filename, thumb: thumb, length: length,
                    file_length: file_length, url: url } }
      jd[:msg][:secret] = secret unless secret.nil?
      jd[:msg][:thumb_secret] = thumb_secret unless thumb_secret.nil?
      jd[:from] = from unless from.nil?
      jd[:ext] = ext unless ext.nil?
      ChatMessage.new request :post, 'messages', json: jd
    end

    def command_to(target, target_type: :users, action:,
                   from: nil, ext: nil)
      jd = { target_type: target_type, target: [*target],
             msg: { type: :cmd, action: action } }
      jd[:from] = from unless from.nil?
      jd[:ext] = ext unless ext.nil?
      ChatMessage.new request :post, 'messages', json: jd
    end
  end
end
