

--函数执行顺序
-- ctor -> onEnter ()
-- remove -> onExit()


--按钮置灰
UIUtil:setNodeIsGrey(btn, true, true ,false, false)

--按键特效
UIUtil:setZoom(btn) 

--按键不可用
btn:setTouchEnabled(false)

--屏蔽滑动条
scrollView:setScrollBarEnabled(false)

--设置滑动区域的大小
scrollView:setInnerContainerSize(scrollView:getContentSize())

--从 studio 获取层
local object, UITable = UIUtil:createLayerFromCSB("guanpin_apply_layer", callBackProvider, true)--加载 csb文件
object:addTo(self)

--触摸向下传递
UINodeTable["img_bg"]:setSwallowTouches(false)--false:向下穿透


--设置字体
node:setFontName("fonts/fzwb.ttf")
node:setFontSize(33)

--设置text控件字体颜色
node:setTextColor(cc.c4b(131, 84, 195, 255))


local strTab = string.split(GoodTab.describe, "/n")
local strMsg = ""
for i = 1 ,#strTab do 
    local des_head = "<ttf fontsize = 22 color = '#005C97' >"
    local des_des = strTab[i]
    local des_tail = "</ttf>"
    strMsg = strMsg..des_head..des_des..des_tail.."<br>"
end 
self:setColorMsg( strMsg, self.UITable["img_bg"])


--部分字体变色 换行 <br>
local showStr = "<ttf fontsize=22 color='#723508'>小主，您确认花费</ttf><ttf fontsize=22 color='#ff0000'>%s元宝</ttf><ttf fontsize=22 color='#723508'>，开启</ttf><ttf fontsize=22 color='#ff0000'>%s</ttf><ttf fontsize=22 color='#723508'>个背包格子么?</ttf>"  --TextUtil.getClientMsgById(11214)
local showStrs = string.format(showStr,needmoney*nums,nums)
self:setColorMsg( showStrs ,"parentNode")

--变色文本
local desTab = {"1.首领连续三天不上线，可进行弹劾", "2.弹劾发起要求", "    等级>50", "    派系累计贡献>3天", "    加入派系>3天", "3.响应弹劾条件", "    等级>40"}
local desColorTab = {'986d34', '986d34', '53a6ab', '53a6ab', '53a6ab', '986d34', '53a6ab'}
local _des = ""
for i=1,#desTab do
	local des_head = "<ttf color = '#"..desColorTab[i].."' fontsize=22>"
	local des_tail = "</ttf>"
	_des = _des..des_head..desTab[i]..des_tail.."<br>"
end
scrollViewSize.width / 2

function ChallengeRecordLayer:setColorMsg( msg, scrollViewSize.width / 2, parentNode)
	if msg ~= nil then
		local paratype = type(msg)
		if paratype == "string" then
			local formatLabel = cc.CCFormatLabel:CreateFormatLabelByHtmlString(msg, 20 * 16, 20 + 2, 0, true, "fonts/fzwb.ttf")--参数：内容，一行宽度，一行高度，对其方式（0左1中2右），是否自动换行，字体
			local size = formatLabel:getContentSize()
			parentNode:setContentSize(cc.size(size.width + 20, size.height + 20))
			formatLabel:setPosition(cc.p(parentNode:getContentSize().width / 2 + 10, parentNode:getContentSize().height / 2))
			formatLabel:addTo(parentNode)
		end
	end
end






--scrollView滑动监听互斥
function GuanPinApplyLayer:addListenerToScrollView(scrollView)
	if not scrollView then
		print("scrollView is nil")
		return
	end

	local containerSize = scrollView:getInnerContainerSize()
	local scrollViewSizeY = scrollView:getContentSize()

	scrollView:addEventListener( function(sender,eventType)
		if eventType == 10 then --开始滑动时
			print("eventType=======>"..eventType)
		elseif eventType == 9 then --滑动ing
			print("eventType=======>"..eventType)	
		elseif eventType == 11 then --手释放
			print("eventType=======>"..eventType)
		elseif eventType == 12 then --惯性滑动停止
			print("eventType=======>"..eventType)
		end
	end)
end


--添加 Layer 监听事件
function GuanPinApplyLayer:addListenerToLayer()
	local callBackProvider = function(node, funcName)

        if node then
			UIUtil:setZoom(node)--按键特效
		end

		if funcName == "btn_close" then	--返回
			return function(sender, eventType)
				self:TouchLogic(sender, eventType, function()--触摸互斥
					require("app.views.GuanPinMainLayer").new(datas):addTo(display.getRunningScene(),GameConst.ALERT_MENU_ZODER)
					self:removeFromParent()
				end)
			end
		elseif funcName == "btn_show" then	--官权阅览
			return function(sender, eventType)
				self:TouchLogic(sender, eventType, function()
					print("btn_show")
				end)
			end
		else
			return function()
			end
		end
	end

	return callBackProvider
end


--代码创建按钮 Button
function GuanQuanLayer:createBtn(index, btnName, imgPath, text, fontPath, fontSize, btnSize, imgType, pressText)   
    --设置三种状态下的图片
    local isPlist = imgType or 0 --是否是图集
    local btn
    if pressText then
        btn = ccui.Button:create(imgPath, pressText, imgPath, isPlist)
    else
        btn = ccui.Button:create(imgPath, imgPath, imgPath, isPlist)
    end
    if not btn then 
        return
    end

    btn:ignoreContentAdaptWithSize(true)--忽略原始大小
    UIUtil:setZoom(btn) --按键特效
    btn:setAnchorPoint(cc.p(0.5,0))
    btn:setScale9Enabled(true)

    btn:setName(btnName)
    btn:setTitleFontName(fontPath)--字体路径
    if index >= 10 then
        btn:setTitleText("从四品开启")
        btn:setTitleFontSize(fontSize)
        btn:setTitleColor(cc.c3b(255, 0, 0))
        btn:setTouchEnabled(false)--按键无效
        UIUtil:setNodeIsGrey(btn, true, true ,false, false) --按钮置灰
    end

    --按钮字体描边
    btn:getTitleRenderer():a(cc.c4b(144, 44, 4, 255), 2)
    btn:getTitleRenderer():enableOutline(cc.c4b(62, 151, 154, 255), 2)--蓝色纹理 合成
    btn:getTitleRenderer():enableOutline(cc.c4b(201, 141, 56, 255), 2)--黄色纹理 获得

    --添加监听
    self:addEventToBtn(btn)

    btn:setCapInsets(cc.rect(11,11,86,86))
    local layout = ccui.LayoutComponent:bindLayoutComponent(btn)
    layout:setSize(btnSize)

    return btn
end

btnJump:addClickEventListener(function( ... )
    --To Do...

    end)

function GuanQuanLayer:addEventToBtn(btn)
	btn:addTouchEventListener(function (sender,eventType)
		self:TouchLogic(sender, eventType, function ()
			funName = sender:getName()
			if funName == "btn_showInfo" then
				print("btn_showInfo")
			elseif funName == "btn_chat" then
				print("btn_inform")
			end
		end)
	end)
end


--创建文本 Text
function GuanQuanLayer:createText(text, fontPath, fontSize)
    -- local text = ccui.Text:create()
    -- text:setString(text)   
    -- text:setFontName(fontPath)
    -- text:setFontSize(fontSize)

    local text = ccui.Text:create(text, fontPath, fontSize)
    text:setTextColor(cc.c4b(0,0,0,255))
    return text
end

--创建文字(可以控制换行) Label
function MomentsPostLayer:createLabel(parent, content, pos)
    local label = cc.Label:createWithTTF(content, "fonts/fzzy.ttf", 20)
    label:setTextColor(cc.c4b(255, 255, 255, 255))
    label:enableOutline(cc.c4b(89, 156, 150, 255), 2)
    label:disableEffect() --取消描边
    label:setMaxLineWidth(30)
    -- label:setLineHeight(linehigh)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:setPosition(pos or cc.p(0, 0))
    label:addTo(parent)
    return label
end

--创建 图片
local pic = cc.Sprite:createWithSpriteFrameName("ui/guanpin/ui_guanping_bg_tiaojian.png")
pic:setPosition(btn:getContentSize().width / 2, btn:getContentSize().height / 2)
pic:addTo(btn)


--输入框文本
function HongYanInteractiveUitil:createEditBox( parent, pos )
    local function editBoxEventHandler(strEventName,pSender)--参数：psender:editBox， strEventName：事件名称
        local str = pSender:getText()
        if strEventName == "began" then
            pSender:setPlaceHolder("")
            print("began")
        elseif strEventName == "return" then--确定
            print("return")
            if str == "" then --输入为空
                pSender:setPlaceHolder("请输入玩家姓名")
            end 

            if string.find(str, "%s") or string.find(str, "%w") or string.find(str, "%p") or string.find(str, "%c") then --分别是：空白字符，字母数字，标点，控制字符
                TextUtil.showMsg("输入格式不正确")
                pSender:setText("")
                pSender:setPlaceHolder("请输入玩家姓名")
                return
            end
            print("输入内容========>"..pSender:getText())
        elseif strEventName == "changed" then--内容变化
            print("changed")
        end         
    end

    local editBox = ccui.EditBox:create(cc.size(232,42), "ui/com/com_translucent_r8/ui_friend_bg_neik.png", 1)--参数：输入框尺寸，背景图片 ，是否在合图里 ui_com_space
    editBox:setAnchorPoint(cc.p(0,0.5))
    editBox:setPlaceHolder("请输入玩家姓名")
    editBox:setPlaceholderFont("fonts/fzzz.ttf",24)--提示文字的字体
    editBox:setPlaceholderFontColor(cc.c3b(224, 191, 192))
    editBox:setFont("fonts/fzzy.ttf", 22)--输入文字的字体
    editBox:setFontColor(cc.c3b(153, 108, 51))
    editBox:setMaxLength(7)--最大字符个数
    editBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)--输入模型，如整数类型，URL，电话号码等，会检测是否符合--用户可以输入任何文字，换行除外 
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)--输入键盘返回类型，done，send，go等KEYBOARD_RETURNTYPE_DONE
    editBox:setPosition(pos)
    editBox:addTo(parent)

    editBox:registerScriptEditBoxHandler(editBoxEventHandler)--editBox监听事件

    return editBox
end


--查找字符 string.find(),未找到返回 nil

str = "9Aa1c3,b "

print(string.find(str, "%s"))--空白字符
print(string.find(str, "%w"))--字母和数字
print(string.find(str, "%p"))--标点
print(string.find(str, "%c"))--控制字符


--动作
function GuanPinApplyLayer:countDownAction(dataTab, node)
    local tabs = {} 
    tabs[#tabs + 1] = cc.CallFunc:create(function()
    --进行操作
    end)

    tabs[#tabs + 1] = cc.DelayTime:create(1)
    
    local action = transition.sequence(tabs) --顺序
    local action = transition.spawn(tabs) --同时
    self:stopAllActions()
    -- self:runAction(action)
    self:runAction(cc.RepeatForever:create(action))--重复 
end 

local actions = {} 
actions[#actions + 1] = cc.Spawn:create({cc.ScaleTo:create(0.2, 0.3), cc.MoveTo:create(0.2, cc.p(originalPos.x, originalPos.y)), cc.FadeOut:create(0.2)})
actions[#actions + 1] = cc.CallFunc:create(function() modelPanel:removeFromParent() end)
modelPanel:runAction(transition.sequence(actions))


--系统时间 (时分秒) (秒数)
local nowTimeTab = GameUtil.OSDate("*t", toint(UIUtil:GetTime()))	--以表的形式	
local timeTab = GameUtil.OSDate("%Y/%m/%d %H:%M:%S", toint( nowTimeTab.year / 1000 ))	

nowTimeTab===>
+sec [25]
+min [16]
+day [16]
+isdst [false]
+wday [6]
+yday [75]
+year [2018]
+month [3]
+hour [15]

timeTab=====>
2018.3.16 15:16:25

--触摸事件
node:addTouchEventListener( function (sender, eventType) --eventType (0:手按下，1：手拖动滑动，2：手释放，3：手指移除滑动区域并释放)
        -- print("addTouchEventListener():eventType====>"..eventType) 
        if eventType == 0 then 
            print("====>"..eventType)
        elseif eventType == 1 then 
            print("====>"..eventType)
        elseif eventType == 2 then 
            print("====>"..eventType)
        end 
    end)

--scrollview监听事件
scrollView:addEventListener( function(sender, eventType)
	if eventType == 0 then
	    event.name = "SCROLL_TO_TOP"
	elseif eventType == 1 then
	    event.name = "SCROLL_TO_BOTTOM"
	elseif eventType == 2 then
	    event.name = "SCROLL_TO_LEFT"
	elseif eventType == 3 then
	    event.name = "SCROLL_TO_RIGHT"
	elseif eventType == 4 then
	    event.name = "SCROLLING"        --按住滑动
	elseif eventType == 5 then
	    event.name = "BOUNCE_TOP"
	elseif eventType == 6 then
	    event.name = "BOUNCE_BOTTOM"
	elseif eventType == 7 then
	    event.name = "BOUNCE_LEFT"
	elseif eventType == 8 then
	    event.name = "BOUNCE_RIGHT"         --bounce反弹
	elseif eventType == 9 then
	    event.name = "CONTAINER_MOVED"      --松手滑动（包括按住滑动）
	elseif eventType == 10 then             --开始滑动
	    event.name = "SCROLLING_BEGAN"
	elseif eventType == 11 then
	    event.name = "SCROLLING_ENDED"      --松手
	elseif eventType == 12 then
	    event.name = "AUTOSCROLL_ENDED"     --自动滑动停止
	end
end)


	--eventType (0:手按下，1：手拖动滑动，2：手释放，3：手指移除滑动区域并释放)
node:addTouchEventListener( function (sender,eventType)
    -- print("addTouchEventListener():eventType====>"..eventType)
    if eventType == 0 then 
        beginPosY = node:getPositionY()
    elseif eventType == 1 then 
        
    elseif eventType == 2 then 
        curPosY = container:getPositionY()
        local offset = math.abs(curPosY - beginPosY)
        print("offset=======>"..offset)
        if offset <= 5 then--移动距离超过15则可点击
            self.isClick  = true
        end
    end 
end)


--抛事件
GameEvent:PushEvent(GameConst.EVENT_GEM_UPDATE_ATTR_INFO)

--抛事件回调
function GemMainLayer:updateInfo( data )
    if data and data._usedata then 
        local _data = clone(data._usedata)
        print("抛事件数据 is -------", table.tostring(_data))
    end 
end

--绑定事件
function GemMainLayer:onEnter()
    GameEvent:RegisterObjEvent(GameConst.EVENT_GEM_UPDATE_ATTR_INFO ,handler(self, self.updateInfo), self)--绑定事件
end


function GemMainLayer:onExit()
    GameEvent:Remove(self)
end

function MianShengLayer:createScrollView(  )
    scrollView = ccui.ScrollView:create() 
    scrollView:setTouchEnabled(true) 
    scrollView:setBounceEnabled(false) --是否回弹
    scrollView:setDirection(ccui.ScrollViewDir.horizontal) --–水平方向 vertical:竖直
    scrollView:setContentSize(cc.size(display.width, display.height)) --–设置尺寸 
    scrollView:setAnchorPoint(cc.p(0, 0))
    scrollView:setScrollBarWidth(30) --–滚动条的宽度 
    scrollView:setScrollBarEnabled(false)--屏蔽滑动条
    -- scrollView:setScrollBarColor(cc.RED) --–滚动条的颜色 
    -- scrollView:setScrollBarPositionFromCorner(cc.p(2,2)) 
    return scrollView
end


--做视差效果
function MianShengLayer:handle(  )
    --背景
    local bg = self:createMap(5)
    bg:setPosition(cc.p(0, 0))
    bg:addTo(self)

    --创建scrollView
    self.scrollView = self:createScrollView()
    self.scrollView:setPosition(cc.p(0, 0)) 
    self.scrollView:addTo(bg)

    --移动底图    
    local img4 = self:createMap(4)
    local img3 = self:createMap(3)
    local img2 = self:createMap(2)
    local img1 = self:createMap(1)


    --设置scrollView内划区域大小
    self.scrollView:setInnerContainerSize(cc.size(img1:getContentSize().width, self.scrollView.height))

    self.parallax = cc.ParallaxNode:create()
    --添加的精灵 z值 速率 偏移
    self.parallax:addChild(img4, 1, cc.p(0.3, 0), cc.p(0, 0))
    self.parallax:addChild(img3, 1, cc.p(0.5, 0), cc.p(0, 0))
    self.parallax:addChild(img2, 1, cc.p(0.9, 0), cc.p(0, 0))
    self.parallax:addChild(img1, 1, cc.p(1, 0), cc.p(0, 0))

    self.parallax:addTo(self.scrollView)
    self:addListernerToParallax(self.parallax)

    self.minPosX = 0 - img1:getContentSize().width
    self.maxPosX = 0
    -- print("minPos=====>"..self.minPosX)
end

function MianShengLayer:addListernerToParallax( node )

    function onTouchBegan(touch, event)
        self.scrolling = true
        node:stopAllActions()
        self.beginPosX = touch:getLocation().x
        print("getLocation====>"..table.tostring(self.beginPosX))

        return true
    end 

    function onTouchMoved(touch, event)
        self.delta = touch:getDelta()--偏移量
        -- print("偏移量self.delta====>"..table.tostring(self.delta.x))

        local curPosX = node:getPositionX() + self.delta.x

        if self.scrolling  and curPosX >= self.minPosX and curPosX <= self.maxPosX then 
            node:setPositionX(curPosX)
        end
    end

    function onTouchEned(touch, event)
        print("parallax:getPosition()====>"..table.tostring(node:getPosition()))
        self.scrolling = false
    end

    --监听事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)

    listener:registerScriptHandler(onTouchEned, cc.Handler.EVENT_TOUCH_ENDED)

    -- listener:registerScriptHandler(function(touch,event)
    --     end, cc.Handler.EVENT_TOUCH_CANCELLED)

    local dispatcher = node:getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(listener, node)      
end


--立绘
self.roleModel = self:createRoleModel({templateId = 40011, sex = 0}, self.UITable["Node_model"])  


--立绘
function ActorLayer:createRoleModel(data, parentNode)
    local DressModel = require("app.views.DressModel").new()
    local roleModel = DressModel.createWJModel(data, true)--传入武将编号  
    roleModel:addTo(parentNode)
    -- roleModel:setScale(0.6)
    -- roleModel:setAnchorPoint(cc.p(0.5, 1))
    -- print("锚点======>"..table.tostring(roleModel:getAnchorPoint()))
    local rec = roleModel:getBoundingBox()
    roleModel:setPosition(cc.p(0, 0))
    parentNode:setPosition(cc.p(300, -260))
    return roleModel
end


--创建图片
function OfferARewardChallengeLayer:createImage()
    --加载缓存
    local bgFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ui/wujiang/ui_wujiangbeibao_keqingliebiao.png")
    if not bgFrame then
        display.loadSpriteFrames("ui/wujiang/wujiang_language.plist","ui/wujiang/wujiang_language.png")
    end    

    local img = ccui.ImageView:create()
    img:loadTexture("ui/wujiang/ui_wujiangbeibao_keqingliebiao.png", isPlist)
    img:setAnchorPoint(0.5 ,1)
    img:setPosition(cc.p(pos.x, pos.y))
    img:setScale9Enabled(true)
    -- img:setCapInsets(cc.rect(37, 37, 37, 37))--九宫格防失真
    img:addTo(parentNode)

    return img
end


--音效
GameUtil.playAudio(AudioConstData.MUSIC_DAKAI_UI)

GameUtil.playAudio(AudioConstData.MUSIC_GUANBI_UI)

GameUtil.buttonClick()



--获取触摸坐标
-- sender:getTouchBeganPosition()
-- sender:getTouchMovePosition()
-- sender:getTouchEndPosition()

-- 滑动防点击
-- function SendFlowerToActorChoosingLayer:addListenerTo( node )
--     local beginPos = 0
--     local curPos = 0
    
--     --eventType (0:手按下，1：手拖动滑动，2：手释放，3：手指移除滑动区域并释放)
--     node:addTouchEventListener( function (sender,eventType)
--         if eventType == 0 then 
--             beginPos = sender:getTouchBeganPosition()
--         elseif eventType == 2 then 
--             curPos = sender:getTouchEndPosition()
--             local offset = math.abs(curPos.y - beginPos.y)--偏移量
--             -- print("offset=======>"..offset)
--             if offset <= 5 then--移动距离超过5视为可点击
--                 print("node's name ========>"..tostring(node:getName()))
--             end
--         end 
--     end)        
-- end


--scrollview滚动 判断
function GemDressingLayer2:addEventToScrollView( scrollView )
    local begOffset = 0
    local curOffset = 0
    local container = scrollView:getInnerContainer()

    scrollView:addEventListener(function (sender,eventType)
        if eventType == 10 then--开始滑动
            self.isScrolling = false
            begOffset = container:getPositionY()                                                        
        elseif eventType == 11 then--松手
            self.isScrolling = false
        elseif eventType == 4 then --按住滑动
            if not self.isScrolling then
                curOffset = container:getPositionY()
                -- print("offset------->", math.abs(curOffset - begOffset))
                if math.abs(curOffset - begOffset) > 6 then--移动距离超过10则判断为正在滚动
                    self.isScrolling  = true
                end
            end
        end
     end)
end


--播放粒子特效 参数：1.plistPath路径 2.坐标 3.父节点 4.层级
function UIEffectUtil.playParticleEffect( plistPath, pos, parent, order)
    print("jsonPath is -----", plistPath )

    if UIUtil.isFileExist(plistPath) and UIUtil.isFileExist(plistPath) then
        local particleEffect = cc.ParticleSystemQuad:create( plistPath )
        particleEffect:setAutoRemoveOnFinish(true) --设置播放完毕之后自动释放内存
        particleEffect:setPosition(cc.p(pos.x , pos.y))
        particleEffect:addTo(parent, order or 1)
    else
        print("plistPath is nil -----")
        return 
    end
end


--播放骨骼动画 参数：1.json路径 2.atalas路径 3.动画名称 4.坐标 5.父节点 6.是否循环 7.层级
function UIEffectUtil.playSkeletonAnimation( jsonPath, atlasPath, animationName, pos, parent, isLoop, order)
    print("jsonPath, atlasPath, animationName is -----", jsonPath, atlasPath, animationName)

    if UIUtil.isFileExist(jsonPath) and UIUtil.isFileExist(atlasPath) then
        local skeleton = sp.SkeletonAnimation:createWithJsonFile(jsonPath, atlasPath)
        skeleton:update(0)  
        skeleton:setAnimation(0, animationName, isLoop) --第三个参数 是否循环
        -- skeleton:setTimeScale(speed or 1) --播放速率（全局计时器也是用该方法）
        skeleton:setPosition(cc.p(pos.x, pos.y))
        skeleton:setLocalZOrder(order or 1)
        skeleton:addTo(parent)
        return skeleton
    else
        print("jsonPath or atlasPath is nil -----")
        return 
    end
end 

--骨骼动画
function GettingRewardLayer:playAnimation(  )
    local tab = {}
    tab[1] = {skelname = "gongxihuode", animateName = "animation", posX = 568, posY = 450}
    tab[2] = {skelname = "gongxihuode", animateName = "guangxian", posX = 568, posY = 300}

    -- local Tab = {skelname = "gongxihuode", animateName = "xunhuan", posX = 568, posY = 450}


    for i = 1, #tab do 
        local skelData = tab[i]
        local skelPath, atlasPath = ResConst:getGettingRewardSpineRes(skelData.skelname)        
        local effect = sp.SkeletonAnimation:createWithJsonFile(skelPath, atlasPath)
        effect:update(0)

        if i == 1 then --一个不循环，一个循环
            effect:setMix(skelData.animateName, "xunhuan", 0.1)
            effect:setAnimation(0, skelData.animateName, false)
            effect:addAnimation(0, "xunhuan", true)
        else
            effect:setAnimation(0, skelData.animateName, true) --第三个参数为true代表一直播放
            effect:setPosition(cc.p(skelData.posX, skelData.posY))
        end 

        effect:addTo(self.UITable["Image_bg"])
    end 

end


    local tab = {}
    tab[1] = {skelname = "youjian", animateName = "idle", posX = 568, posY = 450}
    tab[2] = {skelname = "youjian", animateName = "in", posX = 568, posY = 300}
    tab[3] = {skelname = "youjian", animateName = "out", posX = 568, posY = 300}




    for i = 1, #tab do 
        local skelData = tab[i]
        if not skelData then 
            break
        end 

        local skelPath, atlasPath = ResConst:getGettingRewardSpineRes(skelData.skelname)        
        local effect = sp.SkeletonAnimation:createWithJsonFile(skelPath, atlasPath)
        effect:update(0)
        effect:setAnimation(0, skelData.animateName, true)
        -- effect:setMix(skelData.animateName, "xunhuan", 0.1)        
        -- effect:addAnimation(0, "xunhuan", true)

        effect:setPosition(cc.p(skelData.posX, skelData.posY))
        effect:addTo(self.UITable["Image_bg"])
    end 


--战斗开场动画
function FightScene:showFightStartAnimation()
    local skelPath = "effect/kaizhan/kaizhan.json"
    local atlasPath = "effect/kaizhan/kaizhan.atlas"     

    if not( UIUtil.isFileExist(skelPath) and UIUtil.isFileExist(atlasPath) ) then
        print("骨骼动画未找到")
        return
    end
    
    local _effect = sp.SkeletonAnimation:createWithJsonFile(skelPath,atlasPath)
    -- _effect:setVisible(false)
    _effect:update(0)  
    _effect:setAnimation(0,"animation",false) --第三个参数 是否循环
    _effect:setAnchorPoint(0.5, 0.5)
    _effect:addTo(self,99999)
    _effect:setPosition(cc.p(display.cx, display.cy))
    _effect:setTimeScale(2.5) --播放速率（全局计时器也是用该方法）如下：
    -- local scheduler = cc.Director:getInstance():getScheduler()
    -- scheduler:setTimeScale(self.__curSpeed) --所有的东西都加快


    --下列三个监听，start和end 需要美工在spine资源里里加上events插入关键帧才会响应
    --无论哪个监听在回调里要对该动画对象进行操作要放在下一帧执行

    --播放开始时监听
    _effect:registerSpineEventHandler(function(event)  
        print("Spine is Start") 
    end, sp.EventType.ANIMATION_START)

    --播放结束时监听
    _effect:registerSpineEventHandler(function(event)  
        print("Spine is End") 
        --_effect:setAnimation(0,"atk1",false)  --注意：这句会崩溃，在end时调用监听者的动作时会崩溃  
    end  
    , sp.EventType.ANIMATION_END)

    --动画播放完之后监听
    _effect:registerSpineEventHandler(function (event)
        print("Spine is Complete") 
        _effect:runAction(cc.CallFunc:create( function()  
                _effect:removeFromParent() 
            end)
        )
    end, sp.EventType.ANIMATION_COMPLETE)
end



--玩家立绘
function GuanChangLayer:createRoleModel( parentNode, sex )
    local Sex = sex or gongApp.avatarModel.sex
    local dressTab =  UIUtil:getCurDressIdTab()
    local DressModel = require("app.views.DressModel").new()
    local state = ""                
    local roleModel, state = DressModel.createPlayerModel(dressTab, Sex)
    roleModel:setPosition(cc.p(parentNode:getContentSize().width / 2, 0))
    roleModel:addTo(parentNode)

    local parentSize = parentNode:getContentSize()
    local rect = roleModel:getBoundingBox()
    if state == "static" then --静态
        rect = roleModel:getContentSize()
    end 
    roleModel:setScale(parentSize.height /rect.height) 
    -- roleModel:setScale(parentSize.height / (rect.height + rect.y)) 

    return roleModel
end 


--判断合图在不在
local imgPath = "ui/zhenfa/ui_zhenfa_btn_back.png"
if not UIUtil:checkTexture(imgPath) then
    display.loadSpriteFrames("ui/zhenfa/zhenfa.plist","ui/zhenfa/zhenfa.png")
end


--判断两张表是否相同
local function isSameTable(tab1, tab2)
    local difTab = {}
    local sameTab = {}

    for k, v in pairs(tab1) do
        difTab[v] = 1
    end

    for k, v in pairs(tab2) do
        sameTab[v] = 1
    end

    local isSame = true
    for k, _ in pairs(difTab) do
        if sameTab[k] then
        else
            isSame = false
            break
        end
    end

    return isSame
end

local isSame = isSameTable({1, 3, 5}, {3, 1, 1})
print(tostring(isSame))


--alpha值，图片的透明度(0-255)(透明-不透明)

    local nodeImg = nil
    local id = 0
    local bOwn = false
    local children = self.root:getChildren()
    local position = sender:getTouchBeganPosition()

    local AlphaValue = 0
    for i = 1, #children do
        local node = children[i]
        po = node:convertToNodeSpace(position)
        AlphaValue = cc.SpriteEx:getInstance():getAlphaNumber(node, po.x,po.y)
        if AlphaValue > 10 then 
            --print("name:"..node:getName())
            local name = node:getName()
            nodeImg = node
            id = tonumber(name)
        end
    end


    --坐标转换
    local worldPos = sender:convertToWorldSpaceAR({x = 0, y = 0})--世界坐标
    local localPos = self.ScrollView:convertToNodeSpace(worldPos)--本地坐标


--节点排序（横竖排列)
    for i = 1, itemNum do
        local number = math.floor((i - 1) / 5) --每行5个，第几行,从 0 开始
        local x = (ItemSize.width / 2) + (i - 1) * ItemSize.width - 5 * ItemSize.width * number
        local y = height - ItemSize.height / 2 - number * ItemSize.height

        local objectNode, UINodeTable = self:createNode( i )
        objectNode:setPosition(cc.p(x, y) )
        objectNode:addTo(scrollView)

        --保存节点
        table.insert( ItemNodeTab, UINodeTable )  
    end



--创建精灵图片
local spDress = display.newSprite(path)--若在合图里，路径前加# “#ui/send_letter/1.png"
spDress:setPosition({x = dressLocationTemplate.pos[1], y = dressLocationTemplate.pos[2]})

spDress:setName(name)
spDress:setAnchorPoint({x = 0, y = 0})      
spDress:addTo(parentNode, 1)

--子节点不随父节点透明变化
parentNode:setCascadeOpacityEnabled(false)


--创建帧动画
    --按钮animation
    local animation = UIEffectUtil.UIEffectForRealName("smrz_effect", "smrz_effect", 0.1)--创建帧动画
    local sprite = display.newSprite("#ui/com/com_translucent_r8/ui_com_space.png")
    sprite:addTo(UITable["Button_go"])
    sprite:playAnimationOnce(animation , {removeSelf = true })
    sprite:setPosition(cc.p(UITable["Button_go"]:getContentSize().width / 2, UITable["Button_go"]:getContentSize().height / 2))

    --按钮effect循环播放
    sprite:stopAllActions()
    sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
                    
--实名认证按钮特效         
function UIEffectUtil.UIEffectForRealName(folderName, fileName, speed)
    local function getFrameSize()
        local frameCount = 0
        while true do
            local key = string.format("%s_%02d.png", fileName, frameCount + 1)
            print("key===>"..key)
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(key)
            if frame == nil then
                break
            end
            frameCount = frameCount + 1
        end
        return frameCount
    end

    local plist , ccz = string.format( "effect/%s/%s.plist", folderName, fileName), string.format( "effect/%s/%s.png", folderName, fileName)

    print("plist, ccz is -----", tostring(plist), tostring(ccz))

    --cc.SpriteFrameCache:getInstance():addSpriteFrames(plist, ccz)
    display.loadSpriteFrames(plist, ccz, nil)

    local count = getFrameSize()
    local frames = display.newFrames(fileName.."_%02d.png", 1, count)
    print("frames===>"..table.tostring(frames))
    local animation = display.newAnimation(frames, speed)

    return animation
end


--接口
gongApp:showLoading(true)
gongApp.rpc.UserProxy.arenaFightArena(actorId, function(ret)
    gongApp:hideLoading()
    print("ret is -------"..table.tostring(ret))
    if ret then

    else
        print("ret is nil")
    end
end)



--进入空间调用接口
local data = {avatarId = gongApp.avatarModel.id} --原始数据
local base64Str = UIUtil:getHttpParams( data, nil )--params:原始数据, secretKey:秘钥 --转换之后
gongApp:showLoading()   
require("app.net.HttpService").HttpSpace("http://10.10.10.16:7075/personalSpace/enterSpace", base64Str, function (ret)
    print("enterSpace:ret is ------- ", table.tostring(ret))
    gongApp:hideLoading()
    if ret and ret.result then 
        -- callBackFunc()
    end 
end)



--服务端时间戳
local curTime = UIUtil:GetTime() --现在时间
local timestamp = GameUtil.stringFormatDate("%Y-%m-%d %H:%M:%S", Data.createTime / 1000)
Node["Text_timestamp"]:setString(timestamp)


--排序 (1.拥有 2.id从小到大)
function ChangeRolePhotoOrFrameLayer:sortData( data )
    table.sort(data, function (a, b)
        if a.isOwn and b.isOwn then
            if a.id == CurDressOnID then
                return true
            elseif b.id == CurDressOnID then
                return false
            else
                return a.id < b.id
            end                
        else
            if a.isOwn then
                return true
            elseif b.isOwn then
                return false
            else
                return a.id < b.id
            end
        end
    end)
    print("排序------", table.tostring(data))
    return data
end 

    GameEvent:RegisterObjEvent(GameConst.EVENT_DOWNLOAD_CUSTOM_ICON_SUCCESS, handler(self, self.delaySetIconImage), self)

     --玩家头像、头像框
     local headPath, headKuang, isNeedDownload = ResConst:getHeadPhoto(true)
    print("PowerRankLayer:path, kuang, isNeedDownload===>", tostring(headPath), tostring(headKuang), tostring(isNeedDownload))
     Node["Image_headFrame"]:loadTexture(headKuang) 
     if not isNeedDownload then
         Node["Image_head"]:loadTexture(headPath) 
     else
         local iconTab = {}
         iconTab.IconNode = Node["Image_head"]
         iconTab.modelData = {id = gongApp.avatarModel.id, lastCustomPhotoTime = gongApp.avatarModel.avatarVoMap.avatarExtraInfo.lastCustomPhotoTime}
         table.insert(self.iconTable, iconTab)
         require("app.utils.sdkUtil").downloadPortrait(ResConst:genCustomIconFileName(gongApp.avatarModel.id))
     end 


    --玩家头像、头像框
    local headPath, headKuang, isNeedDownload = ResConst:getHeadPhoto(false, data)
    print("PowerRankLayer:path, kuang, isNeedDownload===>", tostring(headPath), tostring(headKuang), tostring(isNeedDownload))
    UITable["Image_frame"]:loadTexture(headKuang) 
    if not isNeedDownload then
        UITable["Image_touxiang"]:loadTexture(headPath) 
    else
        local iconTab = {}
        iconTab.IconNode = UITable["Image_touxiang"]
        iconTab.modelData = {id = data.id, lastCustomPhotoTime = data.avatarExtraInfo.lastCustomPhotoTime}
        table.insert(self.iconTable, iconTab)
        require("app.utils.sdkUtil").downloadPortrait(ResConst:genCustomIconFileName(data.id))
    end 



    --当前VIP等级
    local myVipLx = gongApp.avatarModel.vipLv
    print("myVipLv is -----", myVipLx)

    --VIP数据
    local myVipData = clone(vip_data[myVipLx])
    if not myVipData then return end 
    print("myVipData is -----", table.tostring(myVipData))



    -- 控件置灰
    local allChildren = UIUtil:getAllChildTabByNode(UITable["Panel_bg"])
    for k, v in pairs(allChildren) do 
        UIUtil:setNodeIsGrey(v, true)
        if v:getDescription() == "Label" then --文字控件
            v:setTextColor(cc.c4b(120, 120, 120, 120))
        end 
        print("控件-----", table.tostring(v:getDescription()))
    end 


--艺术字
local artText = ccui.TextAtlas:create(showValue, numPath, 25, 30, "%")
static TextAtlas* create(const std::string& stringValue,const std::string& charMapFile,int itemWidth,int itemHeight,const std::string& startCharMap);
-- 1.stringValue  是指你需要显示的字符串
-- 2.charMapFile  你的艺术字图片的路径
-- 3.itemWidth   *******注意********  单个字符的长度
-- 4.itemHeight  *******注意********  单个字符的宽度
-- 5.startCharMap 字符索引的起始字符   比如你的图片是0123456789，那么起始字符是0， 如果你的图片是./0123456789，那么起始字符是.（当然根据实际需要字符和图片也不需要一一对应）。



--全局计时器
local scheduler = cc.Director:getInstance():getScheduler()

local function timeFunc(  )
    if not self.timeText then return end 
    local time = tonumber(self.timeText:getString()) - 1
    if time > 0 then
        self.timeText:setString(tostring(time))
    else
        if self.timeText:isVisible() then
            self.timeText:setVisible(false)
        end
        if scheduler then --取消定时器
            scheduler:unscheduleScriptEntry(scheduler)
        end
    end
end

local scheduler = cc.Director:getInstance():getScheduler()
scheduler:scheduleScriptFunc(timeFunc, 1, false) --参数: 1.函数 2.间隔时间 3.fasle无线循环


--回调，下一帧执行
node:runAction(cc.CallFunc:create( function()  
    node:removeFromParent() 
    end)
)

--回调，下一帧执行
local scheduler = require("cocos.framework.scheduler")
scheduler.performWithDelayGlobal(function() 
    --To Do
end, 0)


tolua.isnull()

-- 检查指定 Lua 值中保存的 C++ 对象是否已经被删除。
-- 我们在将 C++ 对象保存到 Lua 值后。只要还有 Lua 代码在使用这些值，那么即使 C++ 对象已经被删除了，但 Lua 值仍然会存在。如果此时调用 Lua 值的方法就会出错。
-- 因此可以用 tolua.isnull() 检查 Lua 值中的 C++ 对象是否已经被删除。
-- 已删除 返回 true  没有被删除 返回 false




--加载csb中的帧动画
-- 1.加载动画
-- local roleAction = cc.CSLoader:createTimeline( fileName ) --fileName：文件名"ui/Hero.csb"

-- 2.节点连接动画（不是播放）

-- node:runAction(roleAction)

-- 3.播放动画

roleAction:play(animationName, true) --动画的名字，是否循环

roleAction:gotoFrameAndPlay(0, true) --起始帧数，是否循环

roleAction:gotoFrameAndPlay(0, 10,true) --起始帧数，结束帧数，是否循环

-- 4.动画帧事件监听

-- roleAction:setFrameEventCallFunc(function(frameEventName)
--         print(frameEventName:getEvent())
-- end)

--播放技能名字特效
local object, UITable = UIUtil:createLayerFromCSB("skill_name_layer", nil, true) 
UIUtil:setBgImageScale(UITable["Panel_bg"]) --屏幕适配
UITable["Panel_bg"]:setTouchEnabled(true)
object:setName("skill_name_layer")
object:addTo(self, GameConst.ALERT_MENU_ZODER)
self.skillUITable = UITable

local roleAction = cc.CSLoader:createTimeline("csb/views/skill_name_layer.csb")
object:runAction(roleAction) --绑定动画
roleAction:play("Animation_skill_name", false) --播放动画 Animation_skill_name：在cocos studios中设置动画管理器中添加动画名
self.roleAction = roleAction

roleAction:clearFrameEventCallFunc()
roleAction:setFrameEventCallFunc(function(frame)
    local eventName = frame:getEvent()
    print("eventName is ----", table.tostring(eventName))
    if eventName == "last_frame" then --在cocos studios中选中开始记录动画，然后选中关键帧，再设置事件名称
        print("播放到最后一帧, 隐藏---")
        object:setVisible(false)
    end
end)


--再次播放技能名字特效
if self:getChildByName("skill_name_layer") then
    self:getChildByName("skill_name_layer"):setVisible(true)

    --更换武将模型
    self.skillUITable["Sprite_servant"]:setTexture("zhuanjirole/40004.png")
    --更换技能名字
    self.skillUITable["Sprite_skill_name"]:setTexture("chenghao/chenghao_jipin.png")

    --播放
    local startFrame = roleAction:getStartFrame()
    local endFrame = roleAction:getEndFrame()
    self.roleAction:gotoFrameAndPlay(startFrame, endFrame, false) --起始帧数，结束帧数，是否循环
end



--获取scrollView当前的Y轴百分比
function ActivityExchangeLayer:getScrollViewPercentOfY( scrollView )
    local pos = scrollView:getInnerContainerPosition()
    local ScrollViewSize = scrollView:getContentSize()
    local InnerSize = scrollView:getInnerContainerSize()
    local offsetY = InnerSize.height - ScrollViewSize.height

    local percent = math.abs( pos.y ) / math.abs( offsetY )
    print("percent is -------", table.tostring(percent))

    return percent * 100
end

--跳转到上次浏览位置
local curInnerHeight = self.UITable["scrollView"]:getInnerContainerSize().height
-- print("当前内滑区域的高===>"..table.tostring(curInnerHeight))
-- print("之前内滑区域的高===>"..table.tostring(self.beforeInnerHeight))
local percent = self.beforeInnerHeight / curInnerHeight * 100
self.UITable["ScrollView"]:jumpToPercentVertical( percent )


--遮罩，空白panel
local maskLayer = ccui.Layout:create()
maskLayer:setContentSize(display.width, display.height)
maskLayer:setTouchEnabled(true)
maskLayer:setSwallowTouches(true) --触摸不穿透
maskLayer:setAnchorPoint(0.5, 0.5)
maskLayer:setPosition(cc.p(display.cx, display.cy))
maskLayer:addTo(display.getRunningScene(), GameConst.ALERT_MENU_ZODER)
maskLayer:setBackGroundColorType(1)
maskLayer:setBackGroundColor(cc.c3b(0, 0, 0)) --填充颜色 黑
maskLayer:setBackGroundColorOpacity(255 * 0.7)--填充颜色透明度
maskLayer:addClickEventListener(function(sender)
    print("maskLayer click -------")
end)



display.newLayer(color) --层监听
local function addListenerToSelf( node )

    local function onTouchBegan(touch, event)
        print("onTouchBegan")
        return true
    end 

    local function onTouchMoved(touch, event)
        print("onTouchMoved")
    end

    local function onTouchEned(touch, event)
        print("onTouchEned")
        if not isActive then return end 
    end

    --监听事件
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)

    listener:registerScriptHandler(onTouchEned, cc.Handler.EVENT_TOUCH_ENDED)

    -- listener:registerScriptHandler(function(touch,event)
    --     end, cc.Handler.EVENT_TOUCH_CANCELLED)

    local dispatcher = node:getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(listener, node)      
end

local color = cc.c4b(0, 0, 0, 0)
local newLayer = display.newLayer(color)
newLayer:addTo(self)

--监听
addListenerToLayer(newLayer)



--设置随机数列表
function HongYanInteractivePlayLayer:setRandomNumList( loopCount, randomNumMax ) --loopCount:循环次数, randomNumMax:最大随机数
    --产生随机数
    self.randomNumList = {}

    --递归(无重复产生随机数)
    local function recursiveFunc( )
        local randomNum = math.random(1, randomNumMax)
        if not self.randomNumList[randomNum] then 
            self.randomNumList[randomNum] = randomNum
        else
            recursiveFunc( )
        end 
    end

    for i = 1, loopCount do  
        recursiveFunc()
    end 

    print("self.randomNumList is -----", table.tostring(self.randomNumList))

end 


--打乱数组顺序 
local function random_array(arr)
    local tmp, index
    for i=1, #arr-1 do
        index = math.random(i, #arr)
        if i ~= index then
            tmp = arr[index]
            arr[index] = arr[i]
            arr[i] = tmp
        end
    end
end



function string.widthSingle(inputstr)
    -- 计算字符串宽度
    -- 计算字符串宽度
    local lenInByte = #inputstr
    local width = 0
    local i = 1

    while (i <= lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
         if curByte>0 and curByte<=127 then
            byteCount = 1 --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2 --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3 --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4 --4字节字符
        end
        local char = string.sub(inputstr, i, i+byteCount-1)
        print(char)
        i = i + byteCount -- 重置下一字节的索引
        width = width + 1 -- 字符的个数（长度）
    end
    return width
end 


-- 获取当前日期和时间
local timeTab = GameUtil.OSDate("%Y/%m/%d_%H:%M:%S", UIUtil:GetTime())
local strTab = string.split( timeTab, "_")
local dayStr = strTab[1]
local timeStr = strTab[2]
nodeDay:setString(dayStr)
nodeTime:setString(timeStr)



local function scrollTo(pos)
    local scrollView = self.UITable["ScrollView_map"]
    scrollView:jumpToLeft()
    local size = scrollView:getInnerContainerSize()
    local InnerContainer = scrollView:getInnerContainer()
    local x, y = InnerContainer:getPosition()
    local boundSize = scrollView:getContentSize()
    local prePoint = InnerContainer:convertToWorldSpaceAR(pos)
    local mx = prePoint.x - display.cx
    local my = prePoint.y - display.cy

    if mx < 0 then
        mx = 0
        x = 0
    else
        x = mx + x
    end
    if my < 0 then
        my = 0
        y = 0
    else
        y = y - my
    end

    if pos.y > size.height/2 then
        scrollView:jumpToTop()
    else
        scrollView:jumpToBottom()
    end

    pos.x = (x / (size.width - boundSize.width) )*100
    pos.y = (y / (size.height- boundSize.height) )*100

    if pos.x > 100 then
        pos.x = 100
    elseif pos.x<0 then
        pos.x = 0
    end

    scrollView:jumpToPercentHorizontal(pos.x)
end


-- 裁剪
function HongYanMainLayer:getClippingNode( )
    
    --模板 显示区域
    local stencil = cc.Node:create()
    local mask = display.newSprite("#ui/hongyan/hongyan_translucent_r8/ui_hongyan_qingmidu_jdtdi.png")  -- ui_hongyan_qingmidu_jdtdi ui_hongyan_qingmidu_zhezhao
    local getTexture = mask:getTexture()
    getTexture:setAntiAliasTexParameters() --抗锯齿
    mask:addTo(stencil)

    -- 初始化一个裁剪节点  
    local clippingNode = cc.ClippingNode:create()         
    clippingNode:setAlphaThreshold(0.3) --显示模板中，alpha像素大于0的内容
    clippingNode:setStencil(stencil) --设置模板
    clippingNode:setInverted(false) --显示裁切内容

    --需要裁切的部分 底板
    local pathJson, pathAtlas = ResConst:getEffectSpineRes("qinmidu", "qinmidu") --获取 effect/xxx/ 文件夹下的骨骼资源
    local skelet = sp.SkeletonAnimation:createWithJsonFile(pathJson, pathAtlas)
    -- skelet:setPosition(cc.p(self.UITable["Image_qmd_bg"]:getContentSize().width / 2, self.UITable["Image_qmd_bg"]:getContentSize().height))
    skelet:setAnimation(0, "animation", true)
    skelet:setName("effect_qmd")

    local frame = cc.Node:create()
    skelet:addTo(frame)
    skelet:setPositionY(- 30 )
    self.frame = frame
    -- print("111----", self.frame:getPositionX(), self.frame:getPositionY())

    --添加底板
    clippingNode:addChild(frame)

    clippingNode:addTo(self.UITable["Image_qmd_bg"])
    clippingNode:setPosition(cc.p(self.UITable["Image_qmd_bg"]:getContentSize().width / 2, self.UITable["Image_qmd_bg"]:getContentSize().height / 2))
    -- print("000----", clippingNode:getPositionX(), clippingNode:getPositionY())

    --设置层级
    clippingNode:setLocalZOrder( 1 )
    self.UITable["Image_diguang"]:setLocalZOrder( 2 )
    self.UITable["Image_qmd_light_bg"]:setLocalZOrder( 2 )
end


--返回按钮监听重写
self.UITable["Button_close"]:addTouchEventListener(function (sender, eventType )
    self:TouchLogic(sender, eventType, function ()
        self:removeFromParent()
        
        
    end)
end)


--变色文字描边
function LianXiKeFuLayer:createRepeatNode(id)    
    local wrapperFormatLabel = cc.CCWrapperFormatLabel:Create()
    --问题
    local FONT_PLAIN = 20
    local color = cc.c3b(153, 108, 51)
    local label = cc.CCWrapperLabelTTF:Create(id.content, FONT_PLAIN, color) --CCWrapperLabelTTF * CCWrapperLabelTTF::Create(const string &strText, const float &fFontSize, const Color3B &color)
    wrapperFormatLabel:AddWrapperNode(label)
    --问题时间
    local createTime = GameUtil.stringFormatDate("%m月%d日 %H:%M", id.createTime * 0.001)
    label = cc.CCWrapperLabelTTF:Create(createTime, FONT_PLAIN, color)
    label:setNewLine(true)
    label:setRelativeType(2)
    wrapperFormatLabel:AddWrapperNode(label)

    --回复
    local text2 = id.reply
    if text2 == nil or text2 == "" then
        text2 = "游戏客服：感谢您的建议，我们会对您的问题进行反馈，祝您游戏愉快！"
    end
    label = cc.CCWrapperLabelTTF:Create(text2, FONT_PLAIN, cc.c4b(229, 86, 70, 255))
    label:setNewLine(true)
    wrapperFormatLabel:AddWrapperNode(label)

    --回复时间
    local time2 = id.replyTime
    if time2 == 0 then
        time2 = id.createTime * 0.001
    end
    createTime = GameUtil.stringFormatDate("%m月%d日 %H:%M",time2)
    label = cc.CCWrapperLabelTTF:Create(createTime, FONT_PLAIN, cc.c4b(229, 86, 70, 255))
    label:setNewLine(true)
    label:setRelativeType(2)
    wrapperFormatLabel:AddWrapperNode(label)

    --线
    local ui_bg_xian = "ui/com/com_translucent_r8/ui_com_line2.png"
    local sprite = cc.CCWrapperImageView:Create(ui_bg_xian, false, false) --static CCWrapperImageView * Create(const std::string &imageFileName, const bool &bFlipX, const bool &bFlipY)
    sprite:setNewLine(true)
    sprite:setRelativeType(1)
    sprite:setScale9Enabled(true)
    sprite:setResTypeIsLocal(false)
    sprite:setContentSize(cc.size(456, 6))
    sprite:setRelativePos(cc.p(0, 16))
    wrapperFormatLabel:AddWrapperNode(sprite)

    local formatLabel = cc.CCFormatLabel:CreateFormatLabelByWrapperFormatLabel(wrapperFormatLabel, 430, 30) --static CCFormatLabel * CreateFormatLabelByWrapperFormatLabel(CCWrapperFormatLabel *pWrapperFormatLabel, const int &nLineWidth, const int &nLineHeight, int alignment = 0, const bool &bAutoChangeLine = true)
    formatLabel:setAnchorPoint(0.0, 0.0)
    formatLabel:setPosition(cc.p(10, 0))

    return formatLabel
end

-- local children = formatLabel:getChildren()
local UIUtil = require("app.utils.UIUtil")
for k,v in pairs(UIUtil:getAllChildTabByNode(formatLabel)) do
    if string.find(v:getDescription(), "Label") then
        print("111")
        v:enableOutline(cc.c4b(202, 112, 112 ,255),2)
    end
end


--清除缓存图片 两个方法
display.removeImage(picPath)    

cc.Director:getInstance():getTextureCache():reloadTexture(picPath)



--加减乘除
add, subtract, multiply and divide


--正则表达式
https://www.jb51.net/tools/zhengze.html



