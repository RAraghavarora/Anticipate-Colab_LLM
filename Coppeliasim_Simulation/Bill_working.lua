--lua

sim=require'sim'
simIK=require'simIK'

-- This is just a very basic example on how to make Bill move. 
-- In this case the two hands are linked, but they can also be independent
-- You can also directly manipulate the posture and other parameters of Bill by adjusting the
-- orientation of the 'Bill_posture_target' object for instance


setColor=function(objectTable,colorName,color)
    for i=1,#objectTable,1 do
        if (sim.getObjectType(objectTable[i])==sim.object_shape_type) then
            sim.setShapeColor(objectTable[i],colorName,0,color)
        end
    end
end

function movCallback(q)
    sim.setObjectPose(hands,q,modelBase)
    simIK.handleGroup(ikEnv,ikGroup,{syncWorlds=true,allowError=true})
end

function moveHands(pos)
    local qStart=sim.getObjectPose(hands,modelBase)
    local qGoal=sim.copyTable(qStart)
    qGoal[1]=pos[1]
    qGoal[2]=pos[2]
    qGoal[3]=pos[3]
    sim.moveToPose(-1,qStart,{0.5},{2},{0.1},qGoal,movCallback,nil,{1,1,1,0.1})
end

function movCallback2(m)
    sim.setObjectMatrix(modelBase,m)
end

function sysCall_thread()
    hands=sim.getObject('./hands_demo')
    modelBase=sim.getObject('.')
    local simLeftHandTip=sim.getObject('./leftHand_tip')
    local simLeftHandTarget=sim.getObject('./leftHand_target')
    local simRightHandTip=sim.getObject('./rightHand_tip')
    local simRightHandTarget=sim.getObject('./rightHand_target')
    local simPostureTip=sim.getObject('./posture_tip')
    local simPostureTarget=sim.getObject('./posture_target')
    local simLeftUpperArm=sim.getObject('./leftUpperArm')
    local simLeftArmBendingTip=sim.getObject('./leftArmBending_tip')
    local simLeftArmBendingTarget=sim.getObject('./leftArmBending_target')
    local simRightUpperArm=sim.getObject('./rightUpperArm')
    local simRightArmBendingTip=sim.getObject('./rightArmBending_tip')
    local simRightArmBendingTarget=sim.getObject('./rightArmBending_target')
    local simLowerLegs=sim.getObject('./lowerLegs')
    local simKneeBendingTip=sim.getObject('./kneeBending_tip')
    local simKneeBendingTarget=sim.getObject('./kneeBending_target')
    local simBillBody=sim.getObject('./body')
    local simLeftEllbowPreferredOrientationTip=sim.getObject('./leftEllbowPreferredOrientation_tip')
    local simLeftEllbowPreferredOrientationTarget=sim.getObject('./leftEllbowPreferredOrientation_target')
    local simRightEllbowPreferredOrientationTip=sim.getObject('./rightEllbowPreferredOrientation_tip')
    local simRightEllbowPreferredOrientationTarget=sim.getObject('./rightEllbowPreferredOrientation_target')
    
    ikEnv=simIK.createEnvironment()
    -- Prepare an ik group, using the convenience function 'simIK.addElementFromScene':
    ikGroup=simIK.createGroup(ikEnv)
    simIK.setGroupCalculation(ikEnv,ikGroup,simIK.method_damped_least_squares,0.1,10)
    simIK.addElementFromScene(ikEnv,ikGroup,modelBase,simLeftHandTip,simLeftHandTarget,simIK.constraint_position)
    simIK.addElementFromScene(ikEnv,ikGroup,modelBase,simRightHandTip,simRightHandTarget,simIK.constraint_position)
    simIK.addElementFromScene(ikEnv,ikGroup,modelBase,simPostureTip,simPostureTarget,simIK.constraint_x+simIK.constraint_alpha_beta)
    simIK.addElementFromScene(ikEnv,ikGroup,simLeftUpperArm,simLeftArmBendingTip,simLeftArmBendingTarget,simIK.constraint_gamma)
    simIK.addElementFromScene(ikEnv,ikGroup,simRightUpperArm,simRightArmBendingTip,simRightArmBendingTarget,simIK.constraint_gamma)
    simIK.addElementFromScene(ikEnv,ikGroup,simLowerLegs,simKneeBendingTip,simKneeBendingTarget,simIK.constraint_gamma)
    simIK.addElementFromScene(ikEnv,ikGroup,simBillBody,simLeftEllbowPreferredOrientationTip,simLeftEllbowPreferredOrientationTarget,simIK.constraint_orientation)
    simIK.addElementFromScene(ikEnv,ikGroup,simBillBody,simRightEllbowPreferredOrientationTip,simRightEllbowPreferredOrientationTarget,simIK.constraint_orientation)
    
    randomColors=true
    v=0.4 -- movement velocity
    a=1 -- movement acceleration

    HairColors={4,{0.30,0.22,0.14},{0.75,0.75,0.75},{0.075,0.075,0.075},{0.75,0.68,0.23}}
    skinColors={2,{0.91,0.84,0.75},{0.52,0.45,0.35}}
    shirtColors={5,{0.37,0.46,0.74},{0.54,0.27,0.27},{0.31,0.51,0.33},{0.46,0.46,0.46},{0.18,0.18,0.18}}
    trouserColors={2,{0.4,0.34,0.2},{0.12,0.12,0.12}}
    shoeColors={2,{0.12,0.12,0.12},{0.25,0.12,0.045}}

    -- Initialize to random colors if desired:
    if (randomColors) then
        modelObjects=sim.getObjectsInTree(modelBase)
        math.randomseed(sim.getFloatParam(sim.floatparam_rand)*10000) -- each lua instance should start with a different and 'good' seed
        setColor(modelObjects,'HAIR',HairColors[1+math.random(HairColors[1])])
        setColor(modelObjects,'SKIN',skinColors[1+math.random(skinColors[1])])
        setColor(modelObjects,'SHIRT',shirtColors[1+math.random(shirtColors[1])])
        setColor(modelObjects,'TROUSERS',trouserColors[1+math.random(trouserColors[1])])
        setColor(modelObjects,'SHOE',shoeColors[1+math.random(shoeColors[1])])
    end

    local maxVel={0.1}
    local maxAccel={0.1}
    local maxJerk={0.1}
    while true do
        moveHands({0.4,0,0.9})
        moveHands({0.4,0,1.4})
        moveHands({0.4,0,0.9})
        moveHands({0.2,0,0.9})
        moveHands({0.2,0,0.6})
        moveHands({0.6,0,1.2})
        moveHands({0.2,0,1.6})
        local mStart=sim.getObjectMatrix(modelBase)
        local mGoal=sim.rotateAroundAxis(mStart,{0,0,1},{mStart[4],mStart[8],mStart[12]},math.pi/2)
        sim.moveToPose(-1,mStart,{0.5},{2},{0.1},mGoal,movCallback2,nil,{1,1,1,0.1})
    end
end

function sysCall_cleanup()
    -- Put some clean-up code here:
    -- Before leaving, restore to default colors:
    if (randomColors) then
        local modelObjects=sim.getObjectsInTree(modelBase)
        setColor(modelObjects,'HAIR',HairColors[2])
        setColor(modelObjects,'SKIN',skinColors[2])
        setColor(modelObjects,'SHIRT',shirtColors[2])
        setColor(modelObjects,'TROUSERS',trouserColors[2])
        setColor(modelObjects,'SHOE',shoeColors[2])
    end
end