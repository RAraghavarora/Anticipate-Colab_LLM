(define (domain HRI_dom)


(:requirements :strips :negative-preconditions :typing :disjunctive-preconditions :action-costs)


(:types 
        location obj receptacle - object ; supertype
        food tobake drink slicable ToFry ToBoil ToRoast  sensitive_obj - obj ; supertype
        slicable - food
        vegetable fruit - slicable
        mobileR immobileR - receptacle
        fragile_receptacle - mobileR
)


(:constants
    
    Kitchen Bathroom LivingRoom StoreRoom - location
  
    Faucet Burner oven_switch Remaining_food Remaining_fruit Remaining_baked Remaining_veggy remaining_pizza Dirtydishes Dishwasher_Switch cleaned_dishes extinguisher pizza_base Sauce veggy prepared_pizza_base baked_pizza DustingCloth Clothes Cleaned_clothes Ironed_Clothes folded_clothes washingmachine_Switch Vacuum_Cleaner TV MusicPlayer Computer DustMop trash Medicines Color_lights Laptop_Switch water_bottle - obj

    stove_burner_1 stove_burner_2 stove_burner_3 stove_burner_4 sink countertop oven dustbin_1  fridge shelf rack cabinet washingmachine laundrybag ironing_board closet dining_table working_table - immobileR
    
    pan_1 pan_2 metal_pot office_bag tray tray_with_food - mobileR

    glass plate bowl - fragile_receptacle
)


(:predicates
 
 (agent_near ?r - immobileR ?l - location)
 (human_near ?r - immobileR ?l - location)
 (agent_at ?l - location)
 (Human_at ?l - location)
 (receptacle_at ?r1 - mobileR ?r2 - immobileR ?l - location)
 (B_obj_at ?o - obj ?l - location)
 (stuff_at ?o - obj ?r - immobileR ?l - location)
 (agent_switched_on ?o - obj ?r - immobileR ?l - location)
 (agent_switched_off ?o - obj ?r - immobileR ?l - location)
 (human_switched_on ?o - obj ?r - immobileR ?l - location)
 (human_switched_off ?o - obj ?r - immobileR ?l - location)
 (In_human_hand ?o - obj)
 (In_agent_hand ?o - obj)
 (In_human_handB ?o - obj)
 (In_agent_handB ?o - obj)
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
 (FireExtinguished ?l - location)
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
 (r_at ?r - immobileR ?l - location)
 (salad_prepared ?o1 ?o2 ?o3 - obj)
 (salad ?o - obj)
 (prepared ?o - obj)
 (Is_vc ?o - obj)

;  (charged ?o - obj)
;  (medicines_provided_at ?r - immobileR ?l - location)
;  (bag_prepared ?o1 - obj ?o2 - obj ?o3 - obj)
;  (prepared_clothes ?o - obj ?r - immobileR ?l - location)

 
;  (singing_lullaby ?r - immobileR ?l - location)
;  (party_at ?l - location)
;  (dancing_at ?l - location)
;  (free)

 
(human_hands_occupied_wo)
(agent_hands_occupied_wo)
(human_hands_occupied_wr)
(agent_hands_occupied_wr)
(heavy_obj_in_human_hand)
(heavy_obj_in_agent_hand)
(not_burner ?r - immobileR)


)


(:functions 
    (total-cost)
    (agent_dur ?r1 ?r2 - receptacle)
    (human_dur ?r1 ?r2 - receptacle)
)


;; Low level tasks



    
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
            (increase(total-cost)(agent_dur ?r1 ?r2)) ;human_fast
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
            (increase(total-cost)(human_dur ?r1 ?r2))
        )                    
)   



; Switching on stuff

(:action Human_Switches_on ; For receptacles
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_switched_off ?o ?r ?l)
                  (human_near ?r ?l)
                  (not(heavy_obj_in_human_hand))
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (not(human_switched_on ?o ?r ?l)))
 :effect(and(not(human_switched_off ?o ?r ?l))
                (human_switched_on ?o ?r ?l)
                (increase (total-cost) 15))
)


(:action Agent_Switches_on ; For receptacles
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_switched_off ?o ?r ?l)
                  (agent_near ?r ?l)
                  (not(heavy_obj_in_agent_hand))
                  (not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (not(agent_switched_on ?o ?r ?l)))
 :effect(and(not(agent_switched_off ?o ?r ?l))
                (agent_switched_on ?o ?r ?l)
                (increase (total-cost) 10))
)


(:action Human_Switches_off ; For receptacles
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_switched_on ?o ?r ?l)
                  (human_near ?r ?l)
                  (not(human_switched_off ?o ?r ?l)))
 :effect(and(human_switched_off ?o ?r ?l)
            (not(human_switched_on ?o ?r ?l))
            (increase (total-cost) 15)
        )
)


(:action Agent_Switches_off ; For receptacles
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_switched_on ?o ?r ?l)
                  (agent_near ?r ?l)
                  (not(agent_switched_off ?o ?r ?l)))
 :effect(and(agent_switched_off ?o ?r ?l)
            (not(agent_switched_on ?o ?r ?l))
            (increase (total-cost) 10)
        )
)


(:action agent_Switch_on   ;For big objects
 :parameters(?o - obj ?l - location)
 :precondition(and(agent_switch_off ?o)
                  (agent_at ?l)
                  (B_obj_at ?o ?l)
                  (not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (not(agent_switch_on ?o ?l)))
 :effect(and(not(agent_switch_off ?o))
                (not(human_switch_off ?o))
                (agent_switch_on ?o ?l)
                (increase (total-cost) 10))
)



(:action agent_Switch_off  ;For big objects
 :parameters(?o - obj ?l - location)
 :precondition(and(agent_switch_on ?o ?l)
                  (not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (agent_at ?l)
                  (B_obj_at ?o ?l)
                  (not(agent_switch_off ?o)))
 :effect(and(agent_switch_off ?o)
            (not(agent_switch_on ?o ?l))
            (not(human_switch_on ?o ?l))
            (increase (total-cost) 10)
        )
)




(:action human_Switch_on ;For big objects
 :parameters(?o - obj ?l - location)
 :precondition(and(human_switch_off ?o)
                  (human_at ?l)
                  (B_obj_at ?o ?l)
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (not(human_switch_on ?o ?l)))
 :effect(and(not(human_switch_off ?o))
                (not(agent_switch_off ?o))
                (human_switch_on ?o ?l)
                (increase (total-cost) 10))
)


(:action human_Switch_off ;For big objects
 :parameters(?o - obj ?l - location)
 :precondition(and(human_switch_on ?o ?l)
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (human_at ?l)
                  (B_obj_at ?o ?l)
                  (not(human_switch_off ?o)))
 :effect(and(human_switch_off ?o)
            (not(human_switch_on ?o ?l))
            (not(agent_switch_on ?o ?l))
            (increase (total-cost) 10)
 
        )
)


; Moving around objects and receptacles


;AGENT
(:action Agent_PickUp 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(agent_near ?r ?l)
                  (stuff_at ?o ?r ?l)
                  (not(In_agent_hand ?o))
                  (not(heavy_obj_in_agent_hand))
                  )
 :effect(and(In_agent_hand ?o)
            (agent_hands_occupied_wo)
            (not(stuff_at ?o ?r ?l))
            (increase (total-cost) 20)
        )
)

;AGENT
(:action Agent_PutDowns 
 :parameters (?o - obj ?r -  immobileR ?l - location)
 :precondition (and(agent_near ?r ?l)
                   (In_agent_hand ?o)
                   (not_burner ?r)
                )
 :effect (and(not(In_agent_hand ?o))
             (stuff_at ?o ?r ?l)
             (not(agent_hands_occupied_wo))
             (increase (total-cost) 20))  
) 




;HUMAN
(:action Human_Picks 
 :parameters(?o - obj ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (stuff_at ?o ?r ?l)
                  (not(In_human_hand ?o))
                  (not(heavy_obj_in_human_hand))
                  )
 :effect(and(In_human_hand ?o)
            (human_hands_occupied_wo)
            (not(stuff_at ?o ?r ?l))
            (increase (total-cost) 20)
        )
)


;HUMAN
(:action Human_PutDowns 
 :parameters (?o - obj ?r -  immobileR ?l - location)
 :precondition (and(human_near ?r ?l)
                   (In_human_hand ?o)
                   (not_burner ?r)
                )
 :effect (and(not(In_human_hand ?o))
             (not(human_hands_occupied_wo))
             (stuff_at ?o ?r ?l)
             (increase (total-cost) 20))  
) 


;HUMAN
(:action Human_Picks_S 
 :parameters(?o - sensitive_obj ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (stuff_at ?o ?r ?l)
                  (not(heavy_obj_in_human_hand))
                  (not(In_human_hand ?o)))
 :effect(and(In_human_hand ?o)
            (human_hands_occupied_wo)
            (not(stuff_at ?o ?r ?l))
            (increase (total-cost) 15)
        )
)


;HUMAN
(:action Human_PutDowns_S
 :parameters (?o - sensitive_obj ?r -  immobileR ?l - location)
 :precondition (and(human_near ?r ?l)
                   (In_human_hand ?o)
                )
 :effect (and(not(In_human_hand ?o))
             (not(human_hands_occupied_wo))
             (stuff_at ?o ?r ?l)
             (increase (total-cost) 15))  
) 




(:action Agent_PutDown
 :parameters (?o - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and(agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (or(In_agent_hand ?o)(InAgentHand ?o))
                  (not(item_in ?o ?r1 ?r2 ?l))
 )
 :effect(and(item_in ?o ?r1 ?r2 ?l)
            (not(agent_hands_occupied_wo))
            (not(In_agent_hand ?o))
            (receptacle_at ?o ?r2 ?l)
            (increase (total-cost) 10)
)
)



(:action human_PutDown
 :parameters (?o - obj ?r1 - mobileR ?r2 - immobileR ?l)
 :precondition(and(human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (or(In_human_hand ?o)(InHumanHand ?o))
                  (not(item_in ?o ?r1 ?r2 ?l))
 )
 :effect(and(item_in ?o ?r1 ?r2 ?l)
            (not(In_human_hand ?o))
            (not(human_hands_occupied_wo))
            (receptacle_at ?o ?r2 ?l)
            (increase (total-cost) 20)
)
)



(:action human_PutDown_s
 :parameters (?o - sensitive_obj ?r1 - mobileR ?r2 - immobileR ?l)
 :precondition(and(human_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (In_human_hand ?o)
                  (not(item_in ?o ?r1 ?r2 ?l))
 )
 :effect(and(item_in ?o ?r1 ?r2 ?l)
            (not(human_hands_occupied_wo))
            (not(In_human_hand ?o))
            (increase (total-cost) 2)
)
)


;AGENT
(:action Agent_PicksUp_Object ;For big objects
 :parameters(?o - obj  ?l - location)
 :precondition(and(agent_at ?l)
                  (B_obj_at ?o ?l)
                  (not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (not(heavy_obj_in_agent_hand))
                  (not(In_agent_handB ?o)))
 :effect(and(In_agent_handB ?o)
            (not(B_obj_at ?o ?l))
            (heavy_obj_in_agent_hand)
            (increase (total-cost) 10)
        )
)


;HUMAN
(:action Human_PicksUp_Object ;For big objects
 :parameters(?o - obj  ?l - location)
 :precondition(and(Human_at ?l)
                  (B_obj_at ?o ?l)
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (not(heavy_obj_in_human_hand))
                  (not(In_human_handB ?o)))
 :effect(and(In_human_handB ?o)
            (not(B_obj_at ?o ?l))
            (heavy_obj_in_human_hand)
            (increase (total-cost) 30)
        )
)


;AGENT
(:action Agent_PutsDown_Object ;For big objects
 :parameters (?o - obj  ?l - location)
 :precondition (and(agent_at ?l)
                   (In_agent_handB ?o) 
                   (not(B_obj_at ?o ?l))
                )
 :effect (and(not(In_agent_handB ?o))
             (B_obj_at ?o ?l)
             (not(heavy_obj_in_agent_hand))
             (increase (total-cost) 10))  
) 



;HUMAN
(:action Human_PutsDown_Object ;For big objects
 :parameters (?o - obj  ?l - location)
 :precondition (and(Human_at ?l)
                   (In_human_handB ?o)
                   (not(B_obj_at ?o ?l))
                )
 :effect (and(not(In_human_handB ?o))
             (B_obj_at ?o ?l)
             (not(heavy_obj_in_human_hand))
             (increase (total-cost) 30))  
) 



(:action Open                    
 :parameters (?r - immobileR ?l - location)
 :precondition(and(agent_near ?r ?l)
                  (not(open ?r ?l)))
 :effect(and(open ?r ?l)
            (increase (total-cost) 10)
        ) 
)


;HUMAN
(:action Human_PicksUp_FReceptacle
 :parameters(?f - fragile_receptacle ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (receptacle_at ?f ?r ?l)
                  (not(heavy_obj_in_human_hand))
                  (not(InHumanHand ?f)))
 :effect(and(InHumanHand ?f)
            (not(receptacle_at ?f ?r ?l))
            (human_hands_occupied_wr)
            (increase (total-cost) 2)
        )
)


;HUMAN
(:action Human_PutsDown_FReceptacle 
 :parameters (?f - fragile_receptacle ?r - immobileR ?l - location)
 :precondition (and(InHumanHand ?f)
                   (human_near ?r ?l)
                   (not(receptacle_at ?f ?r ?l))
                   (not(human_near stove_burner_1 kitchen))(not(human_near stove_burner_2 kitchen))(not(human_near stove_burner_3 kitchen))(not(human_near stove_burner_4 kitchen))
                )
 :effect (and(not(InHumanHand ?f))
             (receptacle_at ?f ?r ?l)
             (not(human_hands_occupied_wr))
             (increase (total-cost) 2))
) 


;HUMAN
(:action Human_PicksUp_Receptacle
 :parameters(?f - mobileR ?r - immobileR ?l - location)
 :precondition(and(human_near ?r ?l)
                  (receptacle_at ?f ?r ?l)
                  (not(heavy_obj_in_human_hand))
                  (not(InHumanHand ?f)))
 :effect(and(InHumanHand ?f)
            (human_hands_occupied_wr)
            (not(receptacle_at ?f ?r ?l))
            (increase (total-cost) 20)
        )
)


;HUMAN
(:action Human_PutsDown_Receptacle 
 :parameters (?f - mobileR ?r - immobileR ?l - location)
 :precondition (and(InHumanHand ?f)
                   (human_near ?r ?l)
                   (not(receptacle_at ?f ?r ?l))
                )
 :effect (and(not(InHumanHand ?f))
             (not(human_hands_occupied_wr))
             (receptacle_at ?f ?r ?l)
             (increase (total-cost) 20))
) 


;AGENT
(:action Agent_PicksUp_Receptacle
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and(agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (not(heavy_obj_in_agent_hand))
                  (not(InAgentHand ?r1)))
 :effect(and(InAgentHand ?r1)
            (agent_hands_occupied_wr)
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
             (not(agent_hands_occupied_wr))
             (receptacle_at ?r1 ?r2 ?l)
             (increase (total-cost) 10))
             
)  
         





;; High level tasks





(:action agent_holds_hose  ;For vacuum cleaner
 :parameters(?o - obj  ?l - location)
 :precondition(and(agent_at ?l)
                  (B_obj_at ?o ?l)
                  (not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (not(agent_hold ?o ?l))
                  (Is_vc ?o)
 )
 :effect(and(agent_hold ?o ?l)
            (heavy_obj_in_agent_hand)
            (not(Is_vc ?o))
            (increase(total-cost)10))
)



(:action human_holds_hose  ;For vacuum cleaner
 :parameters(?o - obj  ?l - location)
 :precondition(and(human_at ?l)
                  (B_obj_at ?o ?l)
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (Is_vc ?o)
                  (not(human_hold ?o ?l))
 )
 :effect(and(human_hold ?o ?l)
            (heavy_obj_in_human_hand)
            (not(Is_vc ?o))
            (increase(total-cost)10))
)




(:action agent_passes_to_human
 :parameters (?o - obj ?r - receptacle ?l - location) 
 :precondition(and(agent_at ?l)
                  (Human_at ?l)
                  (agent_near ?r ?l)
                  (human_near ?r ?l)
                  (In_agent_handB ?o)
                  (not(In_human_hands ?o ?l))
 )
 :effect(and(In_human_hands ?o ?l)
            (not(In_agent_handB ?o))
            (In_human_handB ?o)
            (human_hands_occupied_wo)
            (heavy_obj_in_human_hand)
            (increase (total-cost) 5)
            )
)



;AGENT
(:action agent_cleans 
 :parameters (?o1 - obj)
 :precondition (and(not(agent_hands_occupied_wo))
                   (not(agent_hands_occupied_wr))
                   (not(heavy_obj_in_agent_hand))
                   (agent_near sink kitchen)
                   (stuff_at ?o1 sink Kitchen)
                   (agent_switched_on faucet sink Kitchen)
                   (not(In_agent_hand ?o1))
                   (not(cleaned ?o1))
                )

 :effect(and(cleaned ?o1)
            (increase (total-cost) 25))
)


;HUMAN
(:action human_cleans 
 :parameters (?o1 - obj)
 :precondition (and(not(human_hands_occupied_wo))
                   (not(human_hands_occupied_wr))
                   (not(heavy_obj_in_human_hand))
                   (human_near sink kitchen)
                   (stuff_at ?o1 sink Kitchen)
                   (not(In_human_hand ?o1))
                   (not(cleaned ?o1))
                   (human_switched_on Faucet sink Kitchen)
                )

 :effect(and(cleaned ?o1)
            (increase (total-cost) 75))
)


;AGENT
(:action agent_slice 
 :parameters(?o1 ?o2 - slicable)
 :precondition (and (not(agent_hands_occupied_wo))
                    (not(agent_hands_occupied_wr))
                    (not(heavy_obj_in_agent_hand))
                    (agent_near countertop kitchen)
                    (stuff_at ?o1 countertop Kitchen)
                    (not(In_agent_hand ?o1))
                    (not(In_agent_hand ?o2))
                    (not(sliced ?o2))
                    (cleaned ?o1)
                    (equal ?o1 ?o2)
                )
 :effect (and(sliced ?o2)
             (stuff_at ?o2 countertop Kitchen)
             (increase (total-cost) 15)
         )                 
)


;HUMAN
(:action human_slice 
 :parameters(?o1 ?o2 - slicable)
 :precondition (and (not(human_hands_occupied_wo))
                    (not(human_hands_occupied_wr))
                    (human_near countertop kitchen)
                    (not(heavy_obj_in_human_hand))
                    (stuff_at ?o1 countertop Kitchen)
                    (not(In_human_hand ?o1))
                    (not(In_human_hand ?o2))
                    (not(sliced ?o2))
                    (cleaned ?o1)
                    (equal ?o1 ?o2)
                )
 :effect (and(sliced ?o2)
             (stuff_at ?o2 countertop Kitchen)
             (increase (total-cost) 30)
         )                 
)




(:action Make_Fruit_Salad
 :parameters (?o1 ?o2 ?o3 ?o4 - fruit)
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (not(heavy_obj_in_agent_hand))
                  (sliced ?o1)(sliced ?o2)(sliced ?o3)
                  (agent_near countertop kitchen)
                  (item_in ?o1 plate countertop kitchen)
                  (item_in ?o2 plate countertop kitchen)
                  (item_in ?o3 plate countertop kitchen)
                  (salad ?o4)
                  (not(salad_prepared ?o1 ?o2 ?o3))
                  (not(prepared ?o4))
              )
 :effect(and(salad_prepared ?o1 ?o2 ?o3)
            (prepared ?o4)
            (stuff_at ?o4 countertop kitchen)
            (increase (total-cost) 80)
        )  
)



;HUMAN
(:action human_cooks  ; Add cooking waste
 :parameters( ?o1 ?o3 - food)
 :precondition (and (not(human_hands_occupied_wo))
                    (not(human_hands_occupied_wr))
                    (cleaned ?o1)
                    (not(heavy_obj_in_human_hand))
                    (human_near stove_burner_1 kitchen)
                    (item_in ?o1 metal_pot stove_burner_1 kitchen)
                    (equal ?o1 ?o3)
                    (not(cooked ?o3))
                    (human_switched_on burner stove_burner_1 Kitchen) 
                )
 :effect (and(cooked ?o3)
             (stuff_at ?o3 stove_burner_1 Kitchen)
             (increase (total-cost) 50)
         )                 
)

;AGENT
(:action agent_cooks
 :parameters( ?o1 ?o3 - food)
 :precondition (and (not(agent_hands_occupied_wo))
                    (not(agent_hands_occupied_wr))
                    (cleaned ?o1)
                    (not(heavy_obj_in_agent_hand))
                    (agent_near stove_burner_1 kitchen)
                    (item_in ?o1 metal_pot stove_burner_1 kitchen)
                    (equal ?o1 ?o3)
                    (not(cooked ?o3))
                    (agent_switched_on burner stove_burner_1 Kitchen) 
                )
 :effect (and(cooked ?o3)
             (stuff_at ?o3 stove_burner_1 Kitchen)
             (increase (total-cost) 80)
         )                 
)



(:action Human_boils
 :parameters (?o1 ?o2 - ToBoil)
 :precondition(and(not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (item_in ?o1 metal_pot stove_burner_2 kitchen)
                  (not(heavy_obj_in_human_hand))
                  (human_near stove_burner_2 kitchen)
                  (equal ?o1 ?o2)
                  (human_switched_on burner stove_burner_2 Kitchen) 
                  (not(boiled ?o2))
              )
 :effect(and(boiled ?o2)
            (stuff_at ?o2 stove_burner_2 kitchen)
            (increase (total-cost) 30)
        )
)


(:action Agent_boils
 :parameters (?o1 ?o2 - ToBoil)
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (item_in ?o1 metal_pot stove_burner_2 kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (agent_near stove_burner_2 kitchen)
                  (equal ?o1 ?o2)
                  (agent_switched_on burner stove_burner_2 Kitchen) 
                  (not(boiled ?o2))
              )
 :effect(and(boiled ?o2)
            (stuff_at ?o2 stove_burner_2 kitchen)
            (increase (total-cost) 15)
        )
)




(:action Human_Roast
 :parameters (?o1 ?o2 - ToRoast)
 :precondition(and(not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (item_in ?o1 pan_1 stove_burner_3 kitchen)
                  (not(heavy_obj_in_human_hand))
                  (equal ?o1 ?o2)
                  (human_near stove_burner_3 kitchen)
                  (human_switched_on burner stove_burner_3 Kitchen) 
                  (not(roasted ?o2))
              )
 :effect(and(roasted ?o2)
            (stuff_at ?o2 stove_burner_3 kitchen)
            (increase (total-cost) 25)
        )
)


(:action Agent_Roast
 :parameters (?o1 ?o2 - ToRoast)
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (item_in ?o1 pan_1 stove_burner_3 kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (equal ?o1 ?o2)
                  (agent_near stove_burner_3 kitchen)
                  (agent_switched_on burner stove_burner_3 Kitchen) 
                  (not(roasted ?o2))
              )
 :effect(and(roasted ?o2)
            (stuff_at ?o2 stove_burner_3 kitchen)
            (increase (total-cost) 60)
        )
)




(:action Human_Prepare_eggs
 :parameters (?o1 ?o2 - ToFry)
 :precondition(and(not(human_hands_occupied_wr))
                  (not(human_hands_occupied_wo))
                  (item_in ?o1 pan_2 stove_burner_4 kitchen)
                  (not(heavy_obj_in_human_hand))
                  (equal ?o1 ?o2)
                  (human_near stove_burner_4 kitchen)
                  (human_switched_on burner stove_burner_4 Kitchen) 
                  (not(egg_prepared ?o2))
              )
 :effect(and(egg_prepared ?o2)
            (stuff_at ?o2 stove_burner_4 kitchen)
            (increase (total-cost) 25)
        )  
)


(:action Agent_Prepare_eggs
 :parameters (?o1 ?o2 - ToFry)
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (item_in ?o1 pan_2 stove_burner_4 kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (equal ?o1 ?o2)
                  (agent_near stove_burner_4 kitchen)
                  (agent_switched_on burner stove_burner_4 Kitchen) 
                  (not(egg_prepared ?o2))
              )
 :effect(and(egg_prepared ?o2)
            (stuff_at ?o2 stove_burner_4 kitchen)
            (increase (total-cost) 80)
        )  
)


; PREPARING PIZZA


;AGENT
(:action agent_prepares_pizza_base
 :parameters()
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (item_in pizza_base pan_1 countertop kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (stuff_at Veggy countertop kitchen)
                  (agent_near countertop kitchen)
                  (stuff_at Sauce countertop kitchen)
                  (not(pizza_base_prepared)))
 :effect(and(pizza_base_prepared)
            (stuff_at prepared_pizza_base countertop kitchen)
            (increase(total-cost)60))

)


;HUMAN
(:action Human_prepares_pizza_base
 :parameters()
 :precondition(and(not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (item_in pizza_base pan_1 countertop kitchen)
                  (not(heavy_obj_in_human_hand))
                  (stuff_at Veggy countertop kitchen)
                  (human_near countertop kitchen)
                  (stuff_at Sauce countertop kitchen)
                  (not(pizza_base_prepared)))
 :effect(and(pizza_base_prepared)
            (stuff_at prepared_pizza_base countertop kitchen)
            (increase(total-cost)20))

)


;AGENT
(:action agent_bake_pizza
 :parameters()
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (agent_near oven Kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (pizza_base_prepared)
                  (stuff_at prepared_pizza_base oven Kitchen)
                  (not(pizza_baked))
                  )
 :effect(and(pizza_baked)
            (stuff_at baked_pizza oven Kitchen)
            (increase(total-cost)20)
            )
 )

;HUMAN
(:action Human_bake_pizza
 :parameters()
 :precondition(and(not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (human_near oven Kitchen)
                  (not(heavy_obj_in_human_hand))
                  (pizza_base_prepared)
                  (stuff_at prepared_pizza_base oven Kitchen)
                  (not(pizza_baked))
                  )
 :effect(and(pizza_baked)
            (stuff_at baked_pizza oven Kitchen)
            (increase(total-cost)60)
            )
 )


;AGENT
(:action Agent_serves_pizza
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and (pizza_baked)
                   (not(heavy_obj_in_agent_hand))
                   (agent_near ?r2 ?l)
                   (receptacle_at ?r1 ?r2 ?l)
                   (stuff_at baked_pizza ?r2 ?l)
                   (not(In_agent_hand baked_pizza))
                   (human_near ?r2 ?l)
                   (not(pizza_served ?r1 ?r2 ?l)))
 :effect(and(pizza_served ?r1 ?r2 ?l)
            (stuff_at remaining_pizza ?r2 ?l)
            (increase(total-cost)20)
 )
)

;HUMAN
(:action Human_serves_pizza
 :parameters(?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and (pizza_baked)
                   (human_near ?r2 ?l)
                   (not(heavy_obj_in_human_hand))
                   (receptacle_at ?r1 ?r2 ?l)
                   (stuff_at baked_pizza ?r2 ?l)
                   (not(In_human_hand baked_pizza))
                   (not(pizza_served ?r1 ?r2 ?l)))
 :effect(and(pizza_served ?r1 ?r2 ?l)
            (stuff_at remaining_pizza ?r2 ?l)
            (increase(total-cost)40)
 )
)



;AGENT
(:action agent_serves_food 
 :parameters(?o1 - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (or(cooked ?o1)(boiled ?o1)(roasted ?o1)(egg_prepared ?o1))
                  (not(heavy_obj_in_agent_hand))
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(food_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(food_served ?o1 ?r1 ?r2 ?l)
            (stuff_at remaining_food ?r2 ?l)
            (increase (total-cost) 20)
        )
)


;HUMAN
(:action human_serves_food 
 :parameters(?o1 - obj ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (or(cooked ?o1)(boiled ?o1)(roasted ?o1)(egg_prepared ?o1))
                  (human_near ?r2 ?l)
                  (not(heavy_obj_in_human_hand))
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_human_hand ?o1))
                  (not(food_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(food_served ?o1 ?r1 ?r2 ?l)
            (stuff_at remaining_food ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 40)
        )
)



;AGENT
(:action agent_serves_fruit 
 :parameters (?o1 - fruit ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (or(sliced ?o1)(prepared ?o1))
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (not(heavy_obj_in_agent_hand))
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(fruit_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(fruit_served ?o1 ?r1 ?r2 ?l)
            (stuff_at Remaining_fruit ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
        )
)




;HUMAN
(:action human_serves_fruit 
 :parameters (?o1 - fruit ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (or(sliced ?o1)(prepared ?o1))
                  (human_near ?r2 ?l)
                  (not(heavy_obj_in_human_hand))
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_human_hand ?o1))
                  (not(fruit_served ?o1 ?r1 ?r2 ?l))
              )
 :effect(and(fruit_served ?o1 ?r1 ?r2 ?l)
            (stuff_at Remaining_fruit ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 40)
        )
)


;AGENT
(:action agent_serves_vegetable 
 :parameters (?o1 - vegetable ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (cleaned ?o1)
                  (cooked ?o1)
                  (agent_near ?r2 ?l)
                  (not(heavy_obj_in_agent_hand))
                  (receptacle_at ?r1 ?r2 ?l)
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(veggy_served ?o1 ?r2 ?r2 ?l))
              )
 :effect(and(veggy_served ?o1 ?r1 ?r2 ?l)
            (stuff_at Remaining_veggy ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
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
                  (not(heavy_obj_in_human_hand))
                  (stuff_at ?o1 ?r2 ?l) 
                  (not(In_human_hand ?o1))
                  (not(veggy_served ?o1 ?r2 ?r2 ?l))
              )
 :effect(and(veggy_served ?o1 ?r1 ?r2 ?l)
            (stuff_at Remaining_veggy ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 40)
        )
)


(:action BakeACake 
 :parameters(?o1 ?o3 - tobake)
 :precondition (and (agent_near oven Kitchen)
                    (not(agent_hands_occupied_wo))
                    (not(agent_hands_occupied_wr))
                    (not(heavy_obj_in_agent_hand))
                    (stuff_at ?o1 oven Kitchen)
                    (not(baked ?o3))
                    (agent_switched_on oven_switch oven Kitchen)
                    (equal ?o1 ?o3)   
                )
 :effect (and(baked ?o3)
             (stuff_at ?o3 oven Kitchen)
             (increase (total-cost) 90)
             
         )                 
)


(:action agent_serves_baked 
 :parameters(?o1 - tobake ?r1 - mobileR ?r2 - immobileR ?l - location )
 :precondition(and
                  (baked ?o1)
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (not(heavy_obj_in_agent_hand))
                  (stuff_at ?o1 ?r2 ?l)
                  (not(In_agent_hand ?o1))
                  (human_near ?r2 ?l)
                  (not(baked_served ?o1 ?r1 ?r2 ?l))
             )
 :effect(and(baked_served ?o1 ?r1 ?r2 ?l)
            (stuff_at Remaining_baked ?r2 ?l)
            (stuff_at dirtydishes ?r2 ?l)
            (increase (total-cost) 20)
        )
)



;AGENT
(:action agent_serves_Drink 
 :parameters (?o - drink ?r1 - mobileR ?r2 - immobileR ?l - location)
 :precondition(and
                  (agent_near ?r2 ?l)
                  (receptacle_at ?r1 ?r2 ?l)
                  (not(heavy_obj_in_agent_hand))
                  (stuff_at ?o ?r2 ?l)
                  (human_near ?r2 ?l)
                  (not(served_drink ?o ?r1 ?r2 ?l))
            ) 
 :effect(and(served_drink ?o ?r1 ?r2 ?l)
            (increase (total-cost) 40)
        )
)


;HUMAN
(:action human_serves_Drink 
 :parameters (?o - drink ?r1 - mobileR ?r2 - immobileR ?l3 - location)
 :precondition(and
                  (human_near ?r2 ?l3)
                  (receptacle_at ?r1 ?r2 ?l3) 
                  (not(heavy_obj_in_human_hand))
                  (stuff_at ?o ?r2 ?l3)
                  (not(served_drink ?o ?r1 ?r2 ?l3))
            ) 
 :effect(and(served_drink ?o ?r1 ?r2 ?l3)
            (increase (total-cost) 10)
        )
)



;AGENT
(:action agent_cleans_remaining_food 
 :parameters (?o1 - obj ?l - location)
 :precondition(and
                  (agent_near dustbin_1 Kitchen)
                  (not(heavy_obj_in_agent_hand))
                  (food_remaining)
                  (stuff_at ?o1 dustbin_1 Kitchen)
                  (not(cleaned_food ?o1 ?l))
              )
 :effect(and(cleaned_food ?o1 ?l)
            (increase (total-cost) 15))
)



;HUMAN
(:action human_cleans_remaining_food 
 :parameters (?o1 - obj ?l - location)
 :precondition(and
                  (human_near dustbin_1 Kitchen)
                  (not(heavy_obj_in_human_hand))
                  (food_remaining)
                  (stuff_at ?o1 dustbin_1 Kitchen)
                  (not(cleaned_food ?o1 ?l))
              )
 :effect(and(cleaned_food ?o1 ?l)
            (increase (total-cost) 20))
)


;AGENT
(:action agent_washingDishes
 :parameters()
 :precondition(and
          (not(agent_hands_occupied_wo))
          (not(agent_hands_occupied_wr))
          (agent_near sink Kitchen)
          (not(heavy_obj_in_agent_hand))
          (stuff_at Dirtydishes sink Kitchen)
          (agent_switched_on faucet sink Kitchen)
          (not(dishes_cleaned))
 ) 
 :effect(and(dishes_cleaned)
            (stuff_at cleaned_dishes sink Kitchen)
            (increase (total-cost) 30)
            )
)


;HUMAN
(:action human_washingDishes
 :parameters()
 :precondition(and
          (not(human_hands_occupied_wo))
          (not(human_hands_occupied_wr))
          (human_near sink Kitchen)
          (not(heavy_obj_in_human_hand))
          (stuff_at Dirtydishes sink Kitchen)
          (human_switched_on faucet sink Kitchen)
          (not(dishes_cleaned))
 ) 
 :effect(and(dishes_cleaned)
            (stuff_at cleaned_dishes sink Kitchen)
            (increase (total-cost) 10)
            )
)



(:action agent_Extinguish_Fire ;For fire extinguisher
 :parameters (?l - location)
 :precondition (and(B_obj_at extinguisher ?l)
                   (agent_at ?l)
                   (agent_switch_on extinguisher ?l)
                   (not(FireExtinguished ?l)
               ))
 :effect(and(FireExtinguished ?l)(increase (total-cost) 50))
)



(:action human_Extinguish_Fire ;For fire extingusiher
 :parameters (?l - location)
 :precondition (and(B_obj_at extinguisher ?l)
                   (human_at ?l)
                   (human_Switch_on extinguisher ?l)
                   (not(FireExtinguished ?l)
               ))
 :effect(and(FireExtinguished ?l)(increase (total-cost) 70))
)




(:action Agent_WashingClothes
 :parameters()
 :precondition(and
                  (agent_near washingmachine Bathroom)
                  (stuff_at Clothes washingmachine Bathroom)
                  (agent_switched_on washingmachine_Switch washingmachine Bathroom)
                  (not(washed_Clothes))
 ) 
 :effect(and(washed_clothes)
            (stuff_at Cleaned_clothes washingmachine Bathroom)
            (increase (total-cost) 40)
 ) 
)



(:action Human_WashingClothes
 :parameters()
 :precondition(and
                  (Human_near washingmachine Bathroom)
                  (stuff_at Clothes washingmachine Bathroom)
                  (human_switched_on washingmachine_Switch washingmachine Bathroom)
                  (not(washed_Clothes))
 ) 
 :effect(and(washed_clothes)
            (stuff_at Cleaned_clothes washingmachine Bathroom)
            (increase (total-cost) 60)
 ) 
)



(:action Agent_IronClothes
 :parameters()
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (washed_clothes)
                  (agent_near ironing_board LivingRoom)
                  (stuff_at Cleaned_clothes ironing_board LivingRoom)
                  (not(Ironedclothes))
 ) 
 :effect(and(Ironedclothes)
            (stuff_at Ironed_clothes ironing_board LivingRoom)
            (increase(total-cost)40)
 )
 )  



(:action Human_IronClothes
 :parameters()
 :precondition(and(not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (washed_clothes)
                  (human_near ironing_board LivingRoom)
                  (stuff_at Cleaned_clothes ironing_board LivingRoom)
                  (not(Ironedclothes))
 ) 
 :effect(and(Ironedclothes)
            (stuff_at Ironed_clothes ironing_board LivingRoom)
            (increase(total-cost)50)
 )
 ) 




(:action Agent_FoldClothes
 :parameters()
 :precondition(and(not(agent_hands_occupied_wo))
                  (not(agent_hands_occupied_wr))
                  (Ironedclothes)
                  (agent_near ironing_board LivingRoom)
                  (stuff_at Ironed_Clothes ironing_board LivingRoom)
                  (not(clothes_folded))
 )
 :effect(and(clothes_folded)
            (stuff_at folded_clothes ironing_board LivingRoom)
            (increase(total-cost)30)
 )
)



(:action Human_FoldClothes
 :parameters()
 :precondition(and(Ironedclothes)
                  (not(human_hands_occupied_wo))
                  (not(human_hands_occupied_wr))
                  (human_near ironing_board LivingRoom)
                  (stuff_at Ironed_Clothes ironing_board LivingRoom)
                  (not(clothes_folded))
 )
 :effect(and(clothes_folded)
            (stuff_at folded_clothes ironing_board LivingRoom)
            (increase(total-cost)50)
 )
)



(:action Laundry_Done 
 :parameters()
 :precondition(and(stuff_at folded_clothes Closet LivingRoom)
                  (not(laundrydone))
 ) 
 :effect(and(laundrydone)(increase (total-cost) 10))
)



(:action agent_starts_cleaning_  ;Vacuum cleaning
:parameters (?l - location) 
:precondition(and
                 (agent_hold vacuum_cleaner ?l)
                 (agent_switch_on vacuum_cleaner ?l)
                 (not(room_cleaned ?l))
                 (not(agent_hands_occupied_wo))
                 (not(agent_hands_occupied_wr))
             ) 
:effect(and(room_cleaned ?l)
           (increase (total-cost) 40)
       )
)



(:action human_starts_cleaning_  ;Vacuum cleaning
:parameters (?l - location)
:precondition(and
                 (not(room_cleaned ?l))
                 (human_hold vacuum_cleaner ?l)
                 (human_switch_on vacuum_cleaner ?l)
                 (not(human_hands_occupied_wo))
                 (not(human_hands_occupied_wr))
             ) 
:effect(and(room_cleaned ?l)
           (increase (total-cost) 50)
       )
)



(:action agent_cleans_electronics
 :parameters (?o - obj ?l - location)
 :precondition(and(agent_at ?l)
                  (In_agent_handB DustingCloth)
                  (not(electronics_cleaned ?o ?l))
              )
 :effect(and(electronics_cleaned ?o ?l)
            (increase (total-cost) 60)
            )
)



(:action Human_cleans_electronics
 :parameters (?o - obj ?l - location)
 :precondition(and(human_at ?l)
                  (or(In_human_hands DustingCloth ?l)(In_human_hand DustingCloth))
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
                   (not(electronic_items_Cleaned))
               ) 
 :effect(electronic_items_Cleaned)
)



(:action house_cleaned  ;Vacuum cleaning
 :parameters()
 :precondition(and(not(all_rooms_cleaned))
                  (room_cleaned Kitchen)
                  (room_cleaned Bathroom)
                  (room_cleaned livingroom)
                  (not(trash_cleared))
              )
 :effect(and(all_rooms_cleaned)
            (trash_cleared)
            (B_obj_at Vacuum_cleaner livingRoom)
        )
)



; (:action attached_for_charging
;  :parameters(?o - obj)
;  :precondition(and(stuff_at ?o working_table   livingRoom)
;                   (not(charged ?o))
;  )
;  :effect(charged ?o)
; )



; (:action agent_provides_medicine
;  :parameters(?r - immobileR ?l - location)
;  :precondition(and(agent_near ?r ?l)
;                   (human_near ?r ?l)
;                   (In_agent_hand Medicines)
;                   (not(medicines_provided_at ?r ?l))          
;  )
;  :effect(medicines_provided_at ?r ?l)
; )


; (:action agent_sings_lullaby ;JustForFun
;  :parameters(?r - immobileR ?l - location)
;  :precondition(and(agent_near ?r ?l)
;                   (human_near ?r ?l)
;                   (not(singing_lullaby ?r ?l))          
;  )
;  :effect(singing_lullaby ?r ?l)
; )



; (:action agent_and_human_starts_dancing ;JustForFun
;  :parameters(?l - location)
;  :precondition(and(agent_at ?l)
;                   (human_at ?l)
;                   (not(dancing_at ?l)) 
;                 ;   (free)         
;  )
;  :effect(dancing_at ?l)
; )



; (:action party_starts
;  :parameters(?o - tobake)
;  :precondition(and(or(agent_switch_on Color_lights livingRoom)  (human_switch_on Color_lights livingRoom))
;                   (human_near working_table livingRoom)
;                   (baked_served ?o plate working_table livingRoom)
;                   (or(agent_switch_on MusicPlayer livingRoom)(human_switch_on MusicPlayer livingRoom))
;                   (not(party_at livingRoom))
;                 ;   (not(free))
; )
;  :effect(and(party_at livingRoom))
; )
 

; (:action prepare_office_bag
;  :parameters(?o1 ?o2 ?o3 - obj) 
;  :precondition(and(item_in ?o1 office_bag working_table
;                   livingRoom)
;                   (item_in ?o2 office_bag working_table livingroom)
;                   (item_in ?o3 office_bag working_table livingRoom)
;                   (not(bag_prepared ?o1 ?o2 ?o3))
;  )
;  :effect(and(bag_prepared ?o1 ?o2 ?o3))
;            )
 
;  )



; (:action clothes_prepared
;  :parameters(?o - obj ?r - immobileR ?l - location)
;  :precondition(and(stuff_at ?o ?r ?l)
;                   (not(prepared_clothes ?o ?r ?l))
;  )
;  :effect(prepared_clothes ?o ?r ?l)
; )

)