--lua

sim=require'sim'
simOMPL=require'simOMPL'
simIK=require'simIK'

function sysCall_init() 
    BillHandle=sim.getObject('.')
    
    legJointHandles={sim.getObject('./leftLegJoint'),sim.getObject('./rightLegJoint')}
    kneeJointHandles={sim.getObject('./leftKneeJoint'),sim.getObject('./rightKneeJoint')}
    ankleJointHandles={sim.getObject('./leftAnkleJoint'),sim.getObject('./rightAnkleJoint')}
    shoulderJointHandles={sim.getObject('./leftShoulderJoint'),sim.getObject('./rightShoulderJoint')}
    elbowJointHandles={sim.getObject('./leftElbowJoint'),sim.getObject('./rightElbowJoint')}
    
    targetHandle=sim.getObject('./goalDummy')
    billObstaclesCollection=sim.createCollection(0)
    sim.addItemToCollection(billObstaclesCollection,sim.handle_all,-1,0)
    sim.addItemToCollection(billObstaclesCollection,sim.handle_tree,BillHandle,1)
    collPairs={sim.getObject('./collisionShapeForPathPlanning'),billObstaclesCollection}
    position = sim.getObjectPosition(BillHandle)
    sim.setObjectPosition(BillHandle,{position[1],position[2],0.3})
    sim.setObjectParent(targetHandle,-1,true)

    velocity=1
    setRandomColors=true
    searchRange=15 -- i.e. +- in x and y
    searchDuration=0.1 -- for each simulation pass, when searching
    searchAlgo=simOMPL.Algorithm.BiTRRT
    displayCollisionFreeNodes=true
    showRealTarget=true
   
    -- Now we set random colors:
    HairColors={4,{0.30,0.22,0.14},{0.75,0.75,0.75},{0.075,0.075,0.075},{0.75,0.68,0.23}}
    skinColors={2,{0.91,0.84,0.75},{0.52,0.45,0.35}}
    shirtColors={5,{0.37,0.46,0.74},{0.54,0.27,0.27},{0.31,0.51,0.33},{0.46,0.46,0.46},{0.18,0.18,0.18}}
    trouserColors={2,{0.4,0.34,0.2},{0.12,0.12,0.12}}
    shoeColors={2,{0.12,0.12,0.12},{0.25,0.12,0.045}}
    if setRandomColors then
        math.randomseed(sim.getFloatParam(sim.floatparam_rand)*10000) -- each lua instance should start with a different and 'good' seed
        setColor('HAIR',HairColors[1+math.random(HairColors[1])])
        setColor('SKIN',skinColors[1+math.random(skinColors[1])])
        setColor('SHIRT',shirtColors[1+math.random(shirtColors[1])])
        setColor('TROUSERS',trouserColors[1+math.random(trouserColors[1])])
        setColor('SHOE',shoeColors[1+math.random(shoeColors[1])])
    end

    -- Data for body movement:
    timings={0,1/21,2/21,3/21,4/21,5/21,6/21,7/21,8/21,9/21,10/21,11/21,12/21,13/21,14/21,15/21,16/21,17/21,18/21,19/21,20/21,21/21}
    legWaypoints={0.237,0.228,0.175,-0.014,-0.133,-0.248,-0.323,-0.450,-0.450,-0.442,-0.407,-0.410,-0.377,-0.303,-0.178,-0.111,-0.010,0.046,0.104,0.145,0.188,0.237}
    kneeWaypoints={0.282,0.403,0.577,0.929,1.026,1.047,0.939,0.664,0.440,0.243,0.230,0.320,0.366,0.332,0.269,0.222,0.133,0.089,0.065,0.073,0.092,0.282}
    ankleWaypoints={-0.133,0.041,0.244,0.382,0.304,0.232,0.266,0.061,-0.090,-0.145,-0.043,0.041,0.001,0.011,-0.099,-0.127,-0.121,-0.120,-0.107,-0.100,-0.090,-0.133}
    shoulderWaypoints={0.028,0.043,0.064,0.078,0.091,0.102,0.170,0.245,0.317,0.337,0.402,0.375,0.331,0.262,0.188,0.102,0.094,0.086,0.080,0.051,0.058,0.028}
    elbowWaypoints={-1.148,-1.080,-1.047,-0.654,-0.517,-0.366,-0.242,-0.117,-0.078,-0.058,-0.031,-0.001,-0.009,0.008,-0.108,-0.131,-0.256,-0.547,-0.709,-0.813,-1.014,-1.148}
end


-- Runs after the simulation is stopped 
function sysCall_cleanup() 
    sim.setObjectParent(targetHandle,BillHandle,true)
    
    -- Restore to initial colors:
    setColor('HAIR',HairColors[2])
    setColor('SKIN',skinColors[2])
    setColor('SHIRT',shirtColors[2])
    setColor('TROUSERS',trouserColors[2])
    setColor('SHOE',shoeColors[2])
end

-- Checking if Bill collides with something or not
function checkCollidesAt(pos)
    local tmp=sim.getObjectPosition(BillHandle)
    sim.setObjectPosition(BillHandle,{pos[1],pos[2],0.3})
    local r=sim.checkCollision(collPairs[1],collPairs[2])
    --print(r)
    sim.setObjectPosition(BillHandle,{tmp[1],tmp[2],0.3})
    return r>0
end

-- Randomly searches and puts points in free space(collision free)
function visualizeCollisionFreeNodes(states)
    if ptCont then
        sim.addDrawingObjectItem(ptCont,nil)
    else
        ptCont=sim.addDrawingObject(sim.drawing_spherepts,0.05,0,-1,1000,{0,1,0})
    end
    if states then
        for i=0,#states/2-1,1 do
            sim.addDrawingObjectItem(ptCont,{states[2*i+1],states[2*i+2],0.025})
        end
    end
end

function movCallback(q)
    sim.setObjectPose(simRightHandTip,q,BillHandle)
    simIK.handleGroup(ikEnv,ikGroup,{syncWorlds=true,allowError=true})
end

function moveHands(pos)
    local qStart=sim.getObjectPose(simRightHandTip,BillHandle)
    local qGoal=sim.copyTable(qStart)
    qGoal[1]=pos[1]
    qGoal[2]=pos[2]
    qGoal[3]=pos[3]
    sim.moveToPose(-1,qStart,{0.5},{2},{0.1},qGoal,movCallback,nil,{1,1,1,0.1})
end

function movCallback2(m)
    sim.setObjectMatrix(BillHandle,m)
end

-- Add latency and get goal pos
function getTargetPosition()
    -- we add some latency
    local p=Vector3(sim.getObjectPosition(targetHandle))
    local t=sim.getSystemTime()
    if prevTargetPosStable==nil then
        prevTargetPosStable=p
        prevTargetPos=p
        prevTimeDiff=t
    end
    --print(prevTargetPosStable:data())
    --print(p)
    --print((prevTargetPos-p):norm())
    if (prevTargetPos-p):norm()>0.01 then
        --print('HI')
        prevTimeDiff=t
    end
    prevTargetPos=p
    --print(sim.getSystemTime()-prevTimeDiff)
    if sim.getSystemTime()-prevTimeDiff>0.25 then
        --print('HEMLO')
        prevTargetPosStable=p
    end
    --print(prevTargetPosStable:data())
    return prevTargetPosStable:data()
end

-- Searched path is visualized with lines
function visualizePath(path)
    if not _lineContainer then
        _lineContainer=sim.addDrawingObject(sim.drawing_lines,3,0,-1,1000,{0.2,0.2,0.2})
    end
    sim.addDrawingObjectItem(_lineContainer,nil)
    if path then
        for i=1,(#path/2)-1,1 do
            local lineDat={path[(i-1)*2+1],path[(i-1)*2+2],0.001,path[i*2+1],path[i*2+2],0.001}
            sim.addDrawingObjectItem(_lineContainer,lineDat)
        end
    end
end

-- Assign random colour to Bill
function setColor(colorName,color)
    local objectTable=sim.getObjectsInTree(BillHandle,sim.object_shape_type)
    for i=1,#objectTable,1 do
        sim.setShapeColor(objectTable[i],colorName,0,color)
    end
end

-- Movement of Bill along the calculated path
function moveBody(dist)
    if dist then
        local t1=math.mod(dist/1,1)
        local t2=math.mod(t1+0.5,1)
      
        sim.setJointPosition(legJointHandles[1],sim.getPathInterpolatedConfig(legWaypoints,timings,t1)[1])
        sim.setJointPosition(kneeJointHandles[1],sim.getPathInterpolatedConfig(kneeWaypoints,timings,t1)[1])
        sim.setJointPosition(ankleJointHandles[1],sim.getPathInterpolatedConfig(ankleWaypoints,timings,t1)[1])
        sim.setJointPosition(shoulderJointHandles[1],sim.getPathInterpolatedConfig(shoulderWaypoints,timings,t1)[1])
        sim.setJointPosition(elbowJointHandles[1],sim.getPathInterpolatedConfig(elbowWaypoints,timings,t1)[1])
        
        sim.setJointPosition(legJointHandles[2],sim.getPathInterpolatedConfig(legWaypoints,timings,t2)[1])
        sim.setJointPosition(kneeJointHandles[2],sim.getPathInterpolatedConfig(kneeWaypoints,timings,t2)[1])
        sim.setJointPosition(ankleJointHandles[2],sim.getPathInterpolatedConfig(ankleWaypoints,timings,t2)[1])
        sim.setJointPosition(shoulderJointHandles[2],sim.getPathInterpolatedConfig(shoulderWaypoints,timings,t2)[1])
        sim.setJointPosition(elbowJointHandles[2],sim.getPathInterpolatedConfig(elbowWaypoints,timings,t2)[1])
    else
        for i=1,2,1 do
            sim.setJointPosition(legJointHandles[i],0)
            sim.setJointPosition(kneeJointHandles[i],0)
            sim.setJointPosition(ankleJointHandles[i],0)
            sim.setJointPosition(shoulderJointHandles[i],0)
            sim.setJointPosition(elbowJointHandles[i],0)
        end
    end
end

function sysCall_thread()
    sim.setStepping(true)
    i=0
    while true do
    i=i+1
        -- Make sure Bill doesn't start in a colliding state:
        while checkCollidesAt(sim.getObjectPosition(BillHandle)) do
            local sp=Vector3(sim.getObjectPosition(BillHandle))
            local gp=Vector3(getTargetPosition())
            local dx=(gp-sp):normalized()
            local l=(gp-sp):norm()
            --print(dx)
            --print(l)
            -- Move Bill to a collision free area
            if l>0.1 then
                sp=sp+dx*sim.getSimulationTimeStep()*velocity
                sim.setObjectPosition(BillHandle,sp:data())
                sim.setObjectOrientation(BillHandle,{0,0,math.atan2(dx[2],dx[1])})
            end
            sim.step()
        end
        
        local sp=Vector3(sim.getObjectPosition(BillHandle))
        local gp=Vector3(getTargetPosition())
        local ogp=Vector3(getTargetPosition())
        -- .norm() calculates the distance between two points (sqrt(x^2+y^2+z^2))
        local l=(gp-sp):norm()
        local ngo
        print("SP: ",sp)
        print("GP: ",gp)
        print("L: ",l)
        
        -- Try to move the goal a bit if in a colliding state or not within reach:
        -- If searchRange is less than l then it would create a dummy/intermediate goal position represented by red goal dummy
        while l>0.1 and (l>searchRange or checkCollidesAt(gp:data()) ) do
            local dx=(sp-gp):normalized()
            l=(gp-sp):norm()
            gp=gp+dx*0.09
            if showRealTarget then
                ngo=true
            end
        end
        -- The red intermediate goal state is defined inside the if condition
        if ngo then
            ngo=sim.copyPasteObjects({targetHandle},1)[1]
            local s=sim.getObjectsInTree(ngo,sim.object_shape_type)
            for i=1,#s,1 do
                sim.setShapeColor(s[i],nil,sim.colorcomponent_ambient_diffuse,{1,0,0})
            end
            sim.setObjectPosition(ngo,gp:data())
        end
    
        if l>0.1 and not checkCollidesAt(gp:data()) then
            local t=simOMPL.createTask('t')
            simOMPL.setAlgorithm(t,searchAlgo)
            -- simOMPL.createStateSpace -> https://forum.coppeliarobotics.com/viewtopic.php?t=7508
            local ss={simOMPL.createStateSpace('2d',simOMPL.StateSpaceType.position2d,BillHandle,{sp[1]-searchRange,sp[2]-searchRange},{sp[1]+searchRange,sp[2]+searchRange},1)}
            simOMPL.setStateSpace(t,ss)
            simOMPL.setCollisionPairs(t,collPairs)
            simOMPL.setStartState(t,{sp:data()[1],sp:data()[2]})
            simOMPL.setGoalState(t,{gp:data()[1],gp:data()[2]})
            simOMPL.setStateValidityCheckingResolution(t,0.001)
            simOMPL.setup(t)
            
            local path
            while path==nil do
                --print("Path Started")
                if simOMPL.solve(t,searchDuration) then
                    sim.step()
                    simOMPL.simplifyPath(t,searchDuration)
                    sim.step()
                    path=simOMPL.getPath(t)
                    visualizePath(path)
                end
                
                if displayCollisionFreeNodes then
                    local states=simOMPL.getPlannerData(t)
                    visualizeCollisionFreeNodes(states)
                end
                sim.step()
                
                local gp2=Vector3(getTargetPosition())
                local l=(gp2-ogp):norm()
                if l>0.1 then -- the goal was moved
                    break
                end
            end
            --print("Checking:")
            if path then
                local pathLengths,totalDist=sim.getPathLengths(path,2)
                local startTime=sim.getSimulationTime()
                local dist=0
                while dist/totalDist<0.999 do
                    dist=(sim.getSimulationTime()-startTime)*velocity
                    local p=sim.getPathInterpolatedConfig(path,pathLengths,dist,{type='quadraticBezier',strength=0.25},{0,0})
                    p[3]=0
                    local pp=sim.getObjectPosition(BillHandle)
                    --print(pp)
                    local dx=p[1]-pp[1]
                    local dy=p[2]-pp[2]
                    sim.setObjectOrientation(BillHandle,{0,0,math.atan2(dy,dx)})
                    sim.setObjectPosition(BillHandle,p)
                    moveBody(dist)
                    sim.step()
                    local gp2=Vector3(getTargetPosition())
                    --print("GP2: ",gp2)
                    --print("ogp: ",ogp)
                    local l=(gp2-ogp):norm()
                    if l>0.1 then
                        break
                    end
                end
            end
            --print(l)
            moveBody()
            visualizePath()
            visualizeCollisionFreeNodes()
        else 
            break
        end
        if ngo then
            sim.removeModel(ngo)
        end
        sim.step()
    end
    local cuphandle = sim.getObject("../Cup")
    local simRightHandTip=sim.getObject('./R_tip')
    local simElbow=sim.getObject('./rightElbowJoint')
    local simShoulder=sim.getObject('./rightShoulderJoint')
    ikEnv=simIK.createEnvironment()
    ikGroup=simIK.createGroup(ikEnv)
    simIK.setGroupCalculation(ikEnv,ikGroup,simIK.method_damped_least_squares,0.1,10)

    simIK.addElementFromScene(ikEnv,ikGroup,simElbow,simRightHandTip,cuphandle,simIK.constraint_position)
    simIK.addElementFromScene(ikEnv,ikGroup,simShoulder,simElbow,simRightHandTip,simIK.constraint_position)
    simIK.addElementFromScene(ikEnv,ikGroup,BillHandle,simShoulder,simElbow,simIK.constraint_position)
    -- simIK.addElementFromScene(ikEnv,ikGroup,,simRightHandTip,simRightHandTarget,simIK.constraint_position)
    -- simIK.addElementFromScene(ikEnv,ikGroup,BillHandle,simPostureTip,simPostureTarget,simIK.constraint_x+simIK.constraint_alpha_beta)
    -- simIK.addElementFromScene(ikEnv,ikGroup,simLeftUpperArm,simLeftArmBendingTip,simLeftArmBendingTarget,simIK.constraint_gamma)
    -- simIK.addElementFromScene(ikEnv,ikGroup,simRightUpperArm,simRightArmBendingTip,simRightArmBendingTarget,simIK.constraint_gamma)
    -- simIK.addElementFromScene(ikEnv,ikGroup,simLowerLegs,simKneeBendingTip,simKneeBendingTarget,simIK.constraint_gamma)
    -- simIK.addElementFromScene(ikEnv,ikGroup,simBillBody,simLeftEllbowPreferredOrientationTip,simLeftEllbowPreferredOrientationTarget,simIK.constraint_orientation)
    -- simIK.addElementFromScene(ikEnv,ikGroup,simBillBody,simRightEllbowPreferredOrientationTip,simRightEllbowPreferredOrientationTarget,simIK.constraint_orientation)
    local maxVel={0.1}
    local maxAccel={0.1}
    local maxJerk={0.1}

    while true do 
        moveHands(sim.getObjectPosition(cuphandle))
        local mStart=sim.getObjectMatrix(BillHandle)
        local mGoal=sim.getObjectPosition(cuphandle)
        sim.moveToPose(-1,mStart,maxVel,maxAccel,maxJerk,mGoal,movCallback2,nil,{1,1,1,0.1})
    end
    print("DONE")
end

