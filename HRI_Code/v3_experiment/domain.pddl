(define (domain HRI_dom)


(:requirements :strips :negative-preconditions :typing :disjunctive-preconditions :action-costs)


(:types 
        location obj receptacle - object ; supertype
        food tobake drink slicable ToFry ToBoil ToRoast - obj ; supertype
        slicable - food
        vegetable fruit - slicable
        mobileR immobileR - receptacle
        fragile_receptacle - mobileR
)


(:constants
    
    Kitchen Bathroom LivingRoom StoreRoom - location
  
    Faucet Burner_1 Burner_2 Burner_3 Burner_4 Oven_switch Remaining_food Remaining_fruit Remaining_baked Remaining_veggy remaining_pizza Dirtydishes Dishwasher_Switch cleaned_dishes extinguisher pizza_base Sauce veggy prepared_pizza_base baked_pizza DustingCloth Clothes Cleaned_clothes Ironed_Clothes folded_clothes WashingMachine_Switch Vacuum_Cleaner TV MusicPlayer Computer DustMop trash - obj

    stove_burner_1 stove_burner_2 stove_burner_3 stove_burner_4 sink CounterTop Oven Dustbin_1  Fridge Shelf Rack Cabinet WashingMachine LaundryBag Ironing_board closet dining_table working_table - immobileR
    
    pan_1 pan_2 metal_pot - mobileR

    glass plate bowl - fragile_receptacle
)


(:predicates
 
 (agent_near ?r - immobileR ?l - location)
 (human_near ?r - immobileR ?l - location)
 (agent_at ?l - location)
 (Human_at ?l - location)
 (receptacle_at ?r1 - mobileR ?r2 - immobileR ?l - location)
 (obj_at ?o - obj ?l - location)
 (stuff_at ?o - obj ?r - immobileR ?l - location)
 (agent_switched_on ?o - obj ?r - immobileR ?l - location)
 (agent_switched_off ?o - obj ?r - immobileR ?l - location)
 (human_switched_on ?o - obj ?r - immobileR ?l - location)
 (human_switched_off ?o - obj ?r - immobileR ?l - location)

 (In_human_hand ?o - obj)
 (In_agent_hand ?o - obj)
 (InAgentHand ?r - mobileR)
 (InHumanHand ?r - mobileR)
 (cleaned ?o - obj)
 (sliced ?o - obj)
 (cooked ?o - obj)
 
 (fruit_served ?o - fruit ?r1 - mobileR ?r2 - immobileR ?l - location)
 (food_served ?o - food ?r1 - mobileR ?r2 - immobileR ?l - location)
 (baked_served ?o - tobake ?r1 - mobileR ?r2 - immobileR ?l - location)
 (equal ?o1 ?o2 - obj)
 (baked ?o - tobake)
 (served_drink ?o1 - drink ?r1 - mobileR ?r2 - immobileR ?l - location)
 (food_remaining)
 (veggy_served ?o1 - vegetable ?r1 - mobileR ?r2 - immobileR ?l - location)
 
 (open ?r - immobileR ?l - location)
 (cleaned_food ?o - obj ?l - location)
 (dishes_cleaned)
 (FireExtinguished)
 (pizza_baked)
 (pizza_base_prepared)
 (pizza_served ?r1 - mobileR ?r2 - immobileR ?l - location)
 
 (washed_clothes)
 (Ironedclothes)
 (clothes_folded)
 (laundrydone)
 (agent_switch_off ?o - obj)
 (agent_switch_on ?o - obj ?l - location)
 (human_switch_off ?o - obj)
 (human_switch_on ?o - obj ?l - location)

 (room_cleaned ?l - location)
 (all_rooms_cleaned)
 (electronics_cleaned ?o - obj ?l - location)
 (electronic_items_Cleaned)
 (In_human_hands ?o - obj ?l - location)
 (trash_cleared)

 (agent_hold ?o - object ?l - location)
 (human_hold ?o - object ?l - location)
 (boiled ?o2 - obj)
 (roasted ?o - obj)
 (egg_prepared ?o - obj)
 (item_in ?o - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 (r_at ?r - receptacle ?l - location)
)


(:functions 
    (duration_ ?l1 ?l2 - location)
    (total-cost)
    (dur ?r1 ?r2 - receptacle)
)


;Low level tasks



(:action agent_holds_hose
 :parameters(?o - obj ?r - receptacle ?l - location)
 :precondition(and(agent_at ?l)
                  (obj_at ?o ?l)
                  (human_near ?r ?l)
                  (agent_near ?r ?l)
                  (not(agent_hold ?o ?l))
 )
 :effect(and(agent_hold ?o ?l)
            (increase(total-cost)2))
)



(:action human_holds_hose
 :parameters(?o - obj ?r - receptacle ?l - location)
 :precondition(and(human_at ?l)
                  (obj_at ?o ?l)
                  (agent_near ?r ?l)
                  (human_near ?r ?l)
                  (not(human_hold ?o ?l))
 )
 :effect(and(human_hold ?o ?l)
            (increase(total-cost)10))
)



(:action agent_passes_to_human
 :parameters (?o - obj ?r - receptacle ?l - location) 
 :precondition(and(agent_at ?l)
                  (Human_at ?l)
                  (agent_near ?r ?l)
                  (human_near ?r ?l)
                  (In_agent_hand ?o)
                  (not(In_human_hands ?o ?l))
 )
 :effect(In_human_hands ?o ?l)
)



;Move between rooms
; (:action move_agent
;  :parameters(?l1 ?l2 - location)
;  :precondition (agent_at ?l1)  
;  :effect(and(not(agent_at ?l1))
;             (agent_at ?l2)
;             (increase(total-cost)1)
;             )
; )

; (:action Human_moves
;  :parameters(?l1 ?l2 - location)
;  :precondition (Human_at ?l1)  
;  :effect(and(not(Human_at ?l1))
;             (Human_at ?l2)
;             (increase(total-cost)1)
;             )
; )


    
; Move between receptacles
(:action Human_moves_BR
 :parameters(?r1 ?r2 - immobileR ?l1 ?l2 - location)
 :precondition(and(human_near ?r1 ?l1) 
                  (human_at ?l1)
                  (r_at ?r1 ?l1)
                  (r_at ?r2 ?l2)
                  )           
 :effect(and(not(human_near ?r1 ?l1))
            (not(Human_at ?l1))
            (Human_at ?l2)
            (human_near ?r2 ?l2)
            (increase(total-cost)(dur ?r1 ?r2))
        )                    
 )  



(:action Agent_moves_BR
 :parameters(?r1 ?r2 - immobileR ?l1 ?l2 - location)
 :precondition(and(agent_near ?r1 ?l1) 
                  (agent_at ?l1)
                  (r_at ?r1 ?l1)
                  (r_at ?r2 ?l2)
                  )           
 :effect(and(not(agent_near ?r1 ?l1))
            (not(agent_at ?l1))
            (agent_at ?l2)
            (agent_near ?r2 ?l2)
            (increase(total-cost)(dur ?r1 ?r2))
        )                    
)   



(:action Human_Switches_on 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_switched_off ?o ?r ?l)
                  (human_near ?r ?l)
                  (not(human_switched_on ?o ?r ?l)))
 :effect(and(not(human_switched_off ?o ?r ?l))
                (human_switched_on ?o ?r ?l)
                (increase (total-cost) 2))
)


(:action Agent_Switches_on 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_switched_off ?o ?r ?l)
                  (agent_near ?r ?l)
                  (not(agent_switched_on ?o ?r ?l)))
 :effect(and(not(agent_switched_off ?o ?r ?l))
                (agent_switched_on ?o ?r ?l)
                (increase (total-cost) 1))
)


(:action Human_Switches_off 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_switched_on ?o ?r ?l)
                  (human_near ?r ?l)
                  (not(human_switched_off ?o ?r ?l)))
 :effect(and(human_switched_off ?o ?r ?l)
            (not(human_switched_on ?o ?r ?l))
            (increase (total-cost) 1)
        )
)


(:action Agent_Switches_off 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_switched_on ?o ?r ?l)
                  (agent_near ?r ?l)
                  (not(agent_switched_off ?o ?r ?l)))
 :effect(and(agent_switched_off ?o ?r ?l)
            (not(agent_switched_on ?o ?r ?l))
            (increase (total-cost) 1)
        )
)


(:action agent_Switch_on 
 :parameters(?o - obj ?l - location)
 :precondition(and(agent_switch_off ?o)
                  (agent_at ?l)
                  (obj_at ?o ?l)
                  (not(agent_switch_on ?o ?l)))
 :effect(and(not(agent_switch_off ?o))
                (agent_switch_on ?o ?l)
                (increase (total-cost) 1))
)


(:action agent_Switch_off 
 :parameters(?o - obj ?l - location)
 :precondition(and(agent_switch_on ?o ?l)
                  (agent_at ?l)
                  (obj_at ?o ?l)
                  (not(agent_switch_off ?o)))
 :effect(and(agent_switch_off ?o)
            (not(agent_switch_on ?o ?l))
        )
)

(:action human_Switch_on 
 :parameters(?o - obj ?l - location)
 :precondition(and(human_switch_off ?o)
                  (human_at ?l)
                  (obj_at ?o ?l)
                  (not(human_switch_on ?o ?l)))
 :effect(and(not(human_switch_off ?o))
                (human_switch_on ?o ?l)
                (increase (total-cost) 1))
)


(:action human_Switch_off 
 :parameters(?o - obj ?l - location)
 :precondition(and(human_switch_on ?o ?l)
                  (human_at ?l)
                  (obj_at ?o ?l)
                  (not(human_switch_off ?o)))
 :effect(and(human_switch_off ?o)
            (not(human_switch_on ?o ?l))
        )
)

;AGENT
(:action Agent_PickUp 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_near ?r ?l)
                  (stuff_at ?o ?r ?l)
                  (not(In_agent_hand ?o)))
 :effect(and(In_agent_hand ?o)
            (not(stuff_at ?o ?r ?l))
            (increase (total-cost) 1)
        )
)



;HUMAN
(:action Human_Picks 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (stuff_at ?o ?r ?l)
                  (not(In_human_hand ?o)))
 :effect(and(In_human_hand ?o)
            (not(stuff_at ?o ?r ?l))
            (increase (total-cost) 5)
        )
)


;AGENT
(:action Agent_PutDowns 
 :parameters (?o - obj ?r -  immobileR ?l - location)
 :precondition (and(agent_near ?r ?l)
                   (In_agent_hand ?o)
                )
 :effect (and(not(In_agent_hand ?o))
             (stuff_at ?o ?r ?l)
             (increase (total-cost) 1))  
) 


(:action Agent_PutDown
 :parameters (?o - obj ?r1 - mobileR ?r2 - immobileR ?l)
 :precondition(and(agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (In_agent_hand ?o)
                  (not(item_in ?o ?r1 ?r2 ?l))
 )
 :effect(and(item_in ?o ?r1 ?r2 ?l)
            (not(In_agent_hand ?o))
            (increase (total-cost) 1)
)
)

(:action human_PutDown
 :parameters (?o - obj ?r1 - mobileR ?r2 - immobileR ?l)
 :precondition(and(human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (In_human_hand ?o)
                  (not(item_in ?o ?r1 ?r2 ?l))
 )
 :effect(and(item_in ?o ?r1 ?r2 ?l)
            (not(In_human_hand ?o))
            (increase (total-cost) 5)
)
)



;HUMAN
(:action Human_PutDowns 
 :parameters (?o - obj ?r -  immobileR ?l - location)
 :precondition (and(human_near ?r ?l)
                   (In_human_hand ?o)
                )
 :effect (and(not(In_human_hand ?o))
             (stuff_at ?o ?r ?l)
             (increase (total-cost) 5))  
) 


;AGENT
(:action Agent_PicksUp_Object 
 :parameters(?o - obj  ?l - location)
 :precondition(and(agent_at ?l)
                  (obj_at ?o ?l)
                ;   (agent_near ?r ?l)
                  (not(In_agent_hand ?o)))
 :effect(and(In_agent_hand ?o)
            (not(obj_at ?o ?l))
            (increase (total-cost) 1)
        )
)


;HUMAN
(:action Human_PicksUp_Object 
 :parameters(?o - obj  ?l - location)
 :precondition(and(Human_at ?l)
                  (obj_at ?o ?l)
                ;   (human_near ?r ?l)
                  (In_human_hands ?o ?l)
                  (not(In_human_hand ?o)))
 :effect(and(In_human_hand ?o)
            (not(obj_at ?o ?l))
            (increase (total-cost) 5)
        )
)


;AGENT
(:action Agent_PutsDown_Object 
 :parameters (?o - obj  ?l - location)
 :precondition (and(agent_at ?l)
                   (In_agent_hand ?o)   
                ;    (agent_near ?r ?l)
                )
 :effect (and(not(In_agent_hand ?o))
             (obj_at ?o ?l)
             (increase (total-cost) 1))  
) 



;HUMAN
(:action Human_PutsDown_Object 
 :parameters (?o - obj  ?l - location)
 :precondition (and(Human_at ?l)
                   (In_human_hand ?o) 
                ;    (human_near ?r ?l)

                )
 :effect (and(not(In_human_hand ?o))
             (obj_at ?o ?l)
             (increase (total-cost) 5))  
) 

(:action Open                    
 :parameters (?r - immobileR ?l - location)
 :precondition(and(agent_near ?r ?l)
                  (not(open ?r ?l)))
 :effect(and(open ?r ?l)
            (increase (total-cost) 2)
        ) 
)


;HUMAN
(:action Human_PicksUp_Receptacle
 :parameters(?f - fragile_receptacle ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (receptacle_at ?f ?r ?l)
                  (not(InHumanHand ?f)))
 :effect(and(InHumanHand ?f)
            (not(receptacle_at ?f ?r ?l))
            (increase (total-cost) 1)
        )
)


;HUMAN
(:action Human_PutsDown_Receptacle 
 :parameters (?f - fragile_receptacle ?r - immobileR ?l - location)
 :precondition (and(InHumanHand ?f)
                   (human_near ?r ?l)
                   (not(receptacle_at ?f ?r ?l))
                )
 :effect (and(not(InHumanHand ?f))
             (receptacle_at ?f ?r ?l)
             (increase (total-cost) 1))
) 


;AGENT
(:action Agent_PicksUp_Receptacle
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and(agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (not(InAgentHand ?r1)))
 :effect(and(InAgentHand ?r1)
            (not(receptacle_at ?r1 ?r2 ?l))
            (increase (total-cost) 10)
        )
)


;AGENT
(:action Agent_PutsDown_Receptacle 
 :parameters (?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition (and(InAgentHand ?r1)
                   (agent_near ?r2 ?l)
                   (not(receptacle_at ?r1 ?r2 ?l))
                )
 :effect (and(not(InAgentHand ?r1))
             (receptacle_at ?r1 ?r2 ?l)
             (increase (total-cost) 10))
             
)  
         


;; High level tasks



;AGENT
(:action agent_cleans 
 :parameters (?o1 - obj)
 :precondition (and(agent_near sink kitchen)
                   (stuff_at ?o1 sink Kitchen)
                   (agent_switched_on faucet sink Kitchen)
                   (not(In_agent_hand ?o1))
                   (not(cleaned ?o1))
                )

 :effect(and(cleaned ?o1)
            (increase (total-cost) 5))
)


;HUMAN
(:action human_cleans 
 :parameters (?o1 - obj)
 :precondition (and
                   (human_near sink kitchen)
                   (stuff_at ?o1 sink Kitchen)
                   (not(In_human_hand ?o1))
                   (not(cleaned ?o1))
                   (human_switched_on Faucet sink Kitchen)
                )

 :effect(and(cleaned ?o1)
            (increase (total-cost) 50))
)


;AGENT
(:action agent_slice 
 :parameters(?o1 ?o2 - slicable)
 :precondition (and (agent_near CounterTop kitchen)
                    (stuff_at ?o1 CounterTop Kitchen)
                    (not(In_agent_hand ?o1))
                    (not(In_agent_hand ?o2))
                    (not(sliced ?o2))
                    (cleaned ?o1)
                    (equal ?o1 ?o2)
                )
 :effect (and(sliced ?o2)
             (stuff_at ?o2 CounterTop Kitchen)
             (increase (total-cost) 5)
         )                 
)


;HUMAN
(:action human_slice 
 :parameters(?o1 ?o2 - slicable)
 :precondition (and 
                    (human_near Countertop kitchen)
                    (stuff_at ?o1 CounterTop Kitchen)
                    (not(In_human_hand ?o1))
                    (not(In_human_hand ?o2))
                    (not(sliced ?o2))
                    (cleaned ?o1)
                    (equal ?o1 ?o2)
                )
 :effect (and(sliced ?o2)
             (stuff_at ?o2 CounterTop Kitchen)
             (increase (total-cost) 20)
         )                 
)


;HUMAN
(:action human_cooks
 :parameters( ?o1 ?o3 - food)
 :precondition (and 
                    (cleaned ?o1)
                    (human_near stove_burner_1 kitchen)
                    (item_in ?o1 metal_pot stove_burner_1 kitchen)
                    (equal ?o1 ?o3)
                    (not(cooked ?o3))
                    (human_switched_on burner_1 stove_burner_1 Kitchen) 
                )
 :effect (and(cooked ?o3)
             (stuff_at ?o3 stove_burner_1 Kitchen)
             (increase (total-cost) 50)
         )                 
)

;AGENT
(:action agent_cooks
 :parameters( ?o1 ?o3 - food)
 :precondition (and 
                    (cleaned ?o1)
                    (agent_near stove_burner_1 kitchen)
                    (item_in ?o1 metal_pot stove_burner_1 kitchen)
                    (equal ?o1 ?o3)
                    (not(cooked ?o3))
                    (agent_switched_on burner_1 stove_burner_1 Kitchen) 
                )
 :effect (and(cooked ?o3)
             (stuff_at ?o3 stove_burner_1 Kitchen)
             (increase (total-cost) 200)
         )                 
)



(:action Human_boils
 :parameters (?o1 ?o2 - ToBoil)
 :precondition(and
                  (item_in ?o1 metal_pot stove_burner_2 kitchen)
                  (human_near stove_burner_2 kitchen)
                  (equal ?o1 ?o2)
                  (human_switched_on burner_2 stove_burner_2 Kitchen) 
                  (not(boiled ?o2))
              )
 :effect(and(boiled ?o2)
            (stuff_at ?o2 stove_burner_2 kitchen)
            (increase (total-cost) 50)
        )
)


(:action Agent_boils
 :parameters (?o1 ?o2 - ToBoil)
 :precondition(and
                  (item_in ?o1 metal_pot stove_burner_2 kitchen)
                  (agent_near stove_burner_2 kitchen)
                  (equal ?o1 ?o2)
                  (agent_switched_on burner_2 stove_burner_2 Kitchen) 
                  (not(boiled ?o2))
              )
 :effect(and(boiled ?o2)
            (stuff_at ?o2 stove_burner_2 kitchen)
            (increase (total-cost) 5)
        )
)




(:action Human_Roast
 :parameters (?o1 ?o2 - ToRoast)
 :precondition(and
                  (item_in ?o1 pan_1 stove_burner_3 kitchen)
                  (equal ?o1 ?o2)
                  (human_near stove_burner_3 kitchen)
                  (human_switched_on burner_3 stove_burner_3 Kitchen) 
                  (not(roasted ?o2))
              )
 :effect(and(roasted ?o2)
            (stuff_at ?o2 stove_burner_3 kitchen)
            (increase (total-cost) 5)
        )
)


(:action Agent_Roast
 :parameters (?o1 ?o2 - ToRoast)
 :precondition(and
                  (item_in ?o1 pan_1 stove_burner_3 kitchen)
                  (equal ?o1 ?o2)
                  (agent_near stove_burner_3 kitchen)
                  (agent_switched_on burner_3 stove_burner_3 Kitchen) 
                  (not(roasted ?o2))
              )
 :effect(and(roasted ?o2)
            (stuff_at ?o2 stove_burner_3 kitchen)
            (increase (total-cost) 50)
        )
)




(:action Human_Prepare_eggs
 :parameters (?o1 ?o2 - ToFry)
 :precondition(and
                  (item_in ?o1 pan_2 stove_burner_4 kitchen)
                  (equal ?o1 ?o2)
                  (human_near stove_burner_4 kitchen)
                  (human_switched_on burner_4 stove_burner_4 Kitchen) 
                  (not(egg_prepared ?o2))
              )
 :effect(and(egg_prepared ?o2)
            (stuff_at ?o2 stove_burner_4 kitchen)
            (increase (total-cost) 5)
        )  
)


(:action Agent_Prepare_eggs
 :parameters (?o1 ?o2 - ToFry)
 :precondition(and
                  (item_in ?o1 pan_2 stove_burner_4 kitchen)
                  (equal ?o1 ?o2)
                  (agent_near stove_burner_4 kitchen)
                  (agent_switched_on burner_4 stove_burner_4 Kitchen) 
                  (not(egg_prepared ?o2))
              )
 :effect(and(egg_prepared ?o2)
            (stuff_at ?o2 stove_burner_4 kitchen)
            (increase (total-cost) 100)
        )  
)


; PREPARING PIZZA


;AGENT
(:action agent_prepares_pizza_base
 :parameters()
 :precondition(and
                  (item_in pizza_base pan_1 CounterTop kitchen)
                  (stuff_at Veggy countertop kitchen)
                  (agent_near countertop kitchen)
                  (stuff_at Sauce countertop kitchen)
                  (not(pizza_base_prepared)))
 :effect(and(pizza_base_prepared)
            (stuff_at prepared_pizza_base countertop kitchen)
            (increase(total-cost)50))

)


;HUMAN
(:action Human_prepares_pizza_base
 :parameters()
 :precondition(and
                  (item_in pizza_base pan_1 CounterTop kitchen)
                  (stuff_at Veggy countertop kitchen)
                  (human_near countertop kitchen)
                  (stuff_at Sauce countertop kitchen)
                  (not(pizza_base_prepared)))
 :effect(and(pizza_base_prepared)
            (stuff_at prepared_pizza_base countertop kitchen)
            (increase(total-cost)5))

)


;AGENT
(:action agent_bake_pizza
 :parameters()
 :precondition(and
                  (agent_near Oven Kitchen)
                  (pizza_base_prepared)
                  (stuff_at prepared_pizza_base oven Kitchen)
                  (not(pizza_baked))
                  )
 :effect(and(pizza_baked)
            (stuff_at baked_pizza oven Kitchen)
            (increase(total-cost)5)
            )
 )

;HUMAN
(:action Human_bake_pizza
 :parameters()
 :precondition(and
                  (human_near Oven Kitchen)
                  (pizza_base_prepared)
                  (stuff_at prepared_pizza_base oven Kitchen)
                  (not(pizza_baked))
                  )
 :effect(and(pizza_baked)
            (stuff_at baked_pizza oven Kitchen)
            (increase(total-cost)50)
            )
 )


;AGENT
(:action Agent_serves_pizza
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and (pizza_baked)
                   (agent_near ?r2 ?l)
                   (receptacle_at ?r1 ?r2 ?l)
                   (stuff_at baked_pizza ?r2 ?l)
                   (not(In_agent_hand baked_pizza))
                   (human_near ?r2 ?l)
                   (not(pizza_served ?r1 ?r2 ?l)))
 :effect(and(pizza_served ?r1 ?r2 ?l)
            (obj_at baked_pizza ?l)
            (stuff_at remaining_pizza ?r2 ?l)
            (increase(total-cost)5)
 )
)

;HUMAN
(:action Human_serves_pizza
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and (pizza_baked)
                   (human_near ?r2 ?l)
                   (receptacle_at ?r1 ?r2 ?l)
                   (stuff_at baked_pizza ?r2 ?l)
                   (not(In_human_hand baked_pizza))
                   (not(pizza_served ?r1 ?r2 ?l)))
 :effect(and(pizza_served ?r1 ?r2 ?l)
            (obj_at baked_pizza ?l)
            (stuff_at remaining_pizza ?r2 ?l)
            (increase(total-cost)20)
 )
)




;AGENT
(:action agent_serves_food 
 :parameters(?o1 - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (or(cooked ?o1)(boiled ?o1)(roasted ?o1)(egg_prepared ?o1))
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(food_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(food_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at remaining_food ?r2 ?l)
            (increase (total-cost) 5)
        )
)


;HUMAN
(:action human_serves_food 
 :parameters(?o1 - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (or(cooked ?o1)(boiled ?o1)(roasted ?o1)(egg_prepared ?o1))
                  (human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_human_hand ?o1))
                  (not(food_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(food_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at remaining_food ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
        )
)


;AGENT
(:action agent_serves_fruit 
 :parameters (?o1 - fruit ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (sliced ?o1)
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(fruit_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(fruit_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at Remaining_fruit ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 5)
        )
)


;HUMAN
(:action human_serves_fruit 
 :parameters (?o1 - fruit ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (sliced ?o1)
                  (human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_human_hand ?o1))
                  (not(fruit_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(fruit_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at Remaining_fruit ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
        )
)


;AGENT
(:action agent_serves_vegetable 
 :parameters (?o1 - vegetable ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (cleaned ?o1)
                  (cooked ?o1)
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(veggy_served ?o1 ?r2 ?r2 ?l))
              )
 :effect(and(veggy_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at Remaining_veggy ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 5)
        )
)


;HUMAN
(:action human_serves_vegetable 
 :parameters (?o1 - vegetable ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (cleaned ?o1)
                  (cooked ?o1)
                  (human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_human_hand ?o1))
                  (not(veggy_served ?o1 ?r2 ?r2 ?l))
              )
 :effect(and(veggy_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at Remaining_veggy ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
        )
)


(:action BakeACake 
 :parameters(?o1 ?o3 - tobake)
 :precondition (and (agent_near oven Kitchen)
                    (stuff_at ?o1 Oven Kitchen)
                    (not(baked ?o3))
                    (agent_switched_on Oven_switch oven Kitchen)
                    (equal ?o1 ?o3)   
                )
 :effect (and(baked ?o3)
             (stuff_at ?o3 oven Kitchen)
             (increase (total-cost) 120)
             
         )                 
)


(:action agent_serves_baked 
 :parameters(?o1 - tobake ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (baked ?o1)
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(baked_served ?o1 ?r1 ?r2 ?l))
             )
 :effect(and(baked_served ?o1 ?r1 ?r2 ?l)
            (obj_at ?o1 ?l)
            (stuff_at Remaining_baked ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 5)
        )
)



;AGENT
(:action agent_serves_Drink 
 :parameters (?o - drink ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o ?r2 ?l)
                  (human_near ?r2 ?l)
                  (not(served_drink ?o ?r1 ?r2 ?l))
            ) 
 :effect(and(served_drink ?o ?r1 ?r2 ?l)
            (increase (total-cost) 20)
        )
)


;HUMAN
(:action human_serves_Drink 
 :parameters (?o - drink ?r1 - mobileR ?r2 - immobileR ?l3 - location)
 :precondition(and
                  (human_near ?r2 ?l3)
                  (receptacle_at ?r1 ?r2 ?l3) 
                  (stuff_at ?o ?r2 ?l3)
                  (not(served_drink ?o ?r1 ?r2 ?l3))
            ) 
 :effect(and(served_drink ?o ?r1 ?r2 ?l3)
            (increase (total-cost) 5)
        )
)



;AGENT
(:action agent_cleans_remaining_food 
 :parameters (?o1 - obj ?l - location)
 :precondition(and
                  (agent_near Dustbin_1 Kitchen)
                  ;(food_remaining)
                  (stuff_at ?o1 Dustbin_1 Kitchen)
                  (not(cleaned_food ?o1 ?l))
              )
 :effect(and(cleaned_food ?o1 ?l)
            (increase (total-cost) 5))
)



;HUMAN
(:action human_cleans_remaining_food 
 :parameters (?o1 - obj ?l - location)
 :precondition(and
                  (human_near Dustbin_1 Kitchen)
                  (food_remaining)
                  (stuff_at ?o1 Dustbin_1 Kitchen)
                  (not(cleaned_food ?o1 ?l))
              )
 :effect(and(cleaned_food ?o1 ?l)
            (increase (total-cost) 20))
)


;AGENT
(:action agent_washingDishes
 :parameters()
 :precondition(and
          (agent_near sink Kitchen)
          (stuff_at Dirtydishes sink Kitchen)
          (agent_switched_on faucet sink Kitchen)
          (not(dishes_cleaned))
 ) 
 :effect(and(dishes_cleaned)
            (stuff_at cleaned_dishes sink Kitchen)
            (receptacle_at plate countertop kitchen)
            (increase (total-cost) 20)
            )
)


;HUMAN
(:action human_washingDishes
 :parameters()
 :precondition(and
          (human_near sink Kitchen)
          (stuff_at Dirtydishes sink Kitchen)
          (human_switched_on faucet sink Kitchen)
          (not(dishes_cleaned))
 ) 
 :effect(and(dishes_cleaned)
            (stuff_at cleaned_dishes sink Kitchen)
            (receptacle_at plate countertop kitchen)
            (increase (total-cost) 5)
            )
)



(:action agent_Extinguish_Fire ; add the location
 :parameters ()
 :precondition (and(obj_at extinguisher Kitchen)
                   (agent_at Kitchen)
                   (agent_switch_on extinguisher Kitchen)
                   (not(FireExtinguished)
               ))
 :effect(and(FireExtinguished)(increase (total-cost) 5))
)



(:action human_Extinguish_Fire
 :parameters ()
 :precondition (and(obj_at extinguisher Kitchen)
                   (human_at Kitchen)
                   (human_Switch_on extinguisher Kitchen)
                   (not(FireExtinguished)
               ))
 :effect(and(FireExtinguished)(increase (total-cost) 5))
)



(:action Agent_WashingClothes
 :parameters()
 :precondition(and
                  (agent_near WashingMachine Bathroom)
                  (stuff_at Clothes WashingMachine Bathroom)
                  (agent_switched_on WashingMachine_Switch WashingMachine Bathroom)
                  (not(washed_Clothes))
 ) 
 :effect(and(washed_clothes)
            (stuff_at Cleaned_clothes WashingMachine Bathroom)
            (increase (total-cost) 100)
 ) 
)



(:action Human_WashingClothes
 :parameters()
 :precondition(and
                  (Human_near WashingMachine Bathroom)
                  (stuff_at Clothes WashingMachine Bathroom)
                  (human_switched_on WashingMachine_Switch WashingMachine Bathroom)
                  (not(washed_Clothes))
 ) 
 :effect(and(washed_clothes)
            (stuff_at Cleaned_clothes WashingMachine Bathroom)
            (increase (total-cost) 200)
 ) 
)



(:action Agent_IronClothes
 :parameters()
 :precondition(and
                  (washed_clothes)
                  (agent_near Ironing_board LivingRoom)
                  (stuff_at Cleaned_clothes Ironing_board LivingRoom)
                  (not(Ironedclothes))
 ) 
 :effect(and(Ironedclothes)
            (stuff_at Ironed_clothes Ironing_board LivingRoom)
            (increase(total-cost)70)
 )
 )  



(:action Human_IronClothes
 :parameters()
 :precondition(and
                  (washed_clothes)
                  (human_near Ironing_board LivingRoom)
                  (stuff_at Cleaned_clothes Ironing_board LivingRoom)
                  (not(Ironedclothes))
 ) 
 :effect(and(Ironedclothes)
            (stuff_at Ironed_clothes Ironing_board LivingRoom)
            (increase(total-cost)90)
 )
 ) 




(:action Agent_FoldClothes
 :parameters()
 :precondition(and(Ironedclothes)
                  (agent_near Ironing_board LivingRoom)
                  (stuff_at Ironed_Clothes Ironing_board LivingRoom)
                  (not(clothes_folded))
 )
 :effect(and(clothes_folded)
            (stuff_at folded_clothes Ironing_board LivingRoom)
            (increase(total-cost)50)
 )
)



(:action Human_FoldClothes
 :parameters()
 :precondition(and(Ironedclothes)
                  (human_near Ironing_board LivingRoom)
                  (stuff_at Ironed_Clothes Ironing_board LivingRoom)
                  (not(clothes_folded))
 )
 :effect(and(clothes_folded)
            (stuff_at folded_clothes Ironing_board LivingRoom)
            (increase(total-cost)70)
 )
)



(:action Laundry_Done 
 :parameters()
 :precondition(and(stuff_at folded_clothes Closet LivingRoom)
                  (agent_near Closet LivingRoom)
                  (not(laundrydone))
 ) 
 :effect(and(laundrydone)(increase (total-cost) 2))
)



(:action agent_starts_cleaning_
:parameters (?l - location)  ;Add mopping the floor
:precondition(and(agent_at ?l)
                 (not(room_cleaned ?l))
                 (agent_hold vacuum_cleaner ?l)
                 (agent_switch_on vacuum_cleaner ?l)
             ) 
:effect(and(room_cleaned ?l)
           (obj_at vacuum_cleaner ?l)
           (stuff_at trash vacuum_cleaner ?l)
           (increase (total-cost) 10)
       )
)



(:action human_starts_cleaning_   ;Add mopping the floor
:parameters (?l - location)
:precondition(and(Human_at ?l)
                 (not(room_cleaned ?l))
                 (human_hold vacuum_cleaner ?l)
                 (human_switch_on vacuum_cleaner ?l)
             ) 
:effect(and(room_cleaned ?l)
           (obj_at vacuum_cleaner ?l)
           (obj_at trash ?l)
           (increase (total-cost) 30)
       )
)



(:action agent_cleans_electronics
 :parameters (?o - obj ?l - location)
 :precondition(and(agent_at ?l)
                  (In_agent_hand Dustmop)
                  (not(electronics_cleaned ?o ?l))
              )
 :effect(and(electronics_cleaned ?o ?l)
            (increase (total-cost) 60)
            )
)



(:action Human_cleans_electronics
 :parameters (?o - obj ?l - location)
 :precondition(and(human_at ?l)
                  (In_agent_hand DustingCloth)
                  (In_human_hands DustingCloth ?l)
                  (not(electronics_cleaned ?o ?l))
              )
 :effect(and(electronics_cleaned ?o ?l)
            (increase (total-cost) 20)
            )
)



(:action all_electronic_item_cleaned 
 :parameters ()
 :precondition (and(electronics_cleaned TV livingroom)
                   (electronics_cleaned MusicPlayer livingroom)
                   (electronics_cleaned Computer LivingRoom)
                   (electronics_cleaned Oven Kitchen) ;Updated
                   (not(electronic_items_Cleaned))
               ) 
 :effect(electronic_items_Cleaned)
)



(:action house_cleaned
 :parameters()
 :precondition(and(not(all_rooms_cleaned))
                  (room_cleaned Kitchen)
                  (room_cleaned Bathroom)
                  (room_cleaned livingroom)
                  ;(stuff_at trash Dustbin_1 kitchen)
                  (not(trash_cleared))
              )
 :effect(and(all_rooms_cleaned)
            (trash_cleared)
            (obj_at Vacuum_cleaner livingRoom)
 )
    
 

)

; (:action clear_trash
;  :parameters ()
;  :precondition (and 
;     (stuff_at trash Dustbin_1 kitchen)
;     (not(trash_cleared))
;  )
;  :effect(trash_cleared)
; )

)
 

