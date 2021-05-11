module ResponseJson

  def sendResponse codeName,entityData,appendJson
    respond_to do |format|
      format.json { 
        render json: sendJson(codeName,entityData)
                      .merge(appendJson) 
      }         
    end
  end

  def sendJson codeName, entityData
    case codeName
    when "success"
      result = {code: 200, message: "Success"}
    when "customOk"
      result = {code: 200, message: entityData}
    when "custom"
      result = {code: 422, message: entityData}
    when "created"
      result = {code: 201, message: "#{entityData} created successfully" }
    when "accepted"
      result = {code: 202, message: "#{entityData} accepted successfully" }
    when "updated"
      result = {code: 205, message: "#{entityData} updated successfully"}
    when "bad"
      result = {code: 400, message: "Bad Request"}      
    when "unauthorized"
      result = {code: 401, message: "Unauthorized access"}      
    when "suspend"
      result = {code: 403, message: "#{entityData} suspend"}
    when "not"
      result = {code: 405, message: "#{entityData} does not exists"}      
    when "missing"
      result = {code: 422, message: "Bad Request, #{entityData} must be present."}
    when "blank"
      result = {code: 422, message: "#{entityData} can't blank"}
    when "already"
      result = {code: 422, message: "#{entityData} already exists"}
    when "sessionExpired"
      result = {code: 345, message: entityData}
    when "guestExpired"
      result = {code: 123, message: entityData}
    when "customCode"
      # "customCode:customMsgHere" like "302:Custom message here"
      result = {code: entityData.to_s.split(':').first.to_i, message: entityData.to_s.split(':').last}
    else
      result = {code: 420, message: "Unknown Request"}
    end
    result
  end
end
