(define (problem HRI_prob)
(:domain HRI_dom)


(:objects 
          
    Apple Sliced_Apple Mango Sliced_Mango Avocado Sliced_Avocado Fruit_Salad Banana Slice_Banana - fruit
        
    Pasta Cooked_Pasta cereal Cooked_cereal - food

    eggs omelete scrambled_eggs - ToFry

    Raw_eggs boiled_eggs rice cooked_rice lentil cooked_lentil soup prepared_soup - ToBoil

    chicken roasted_chicken bread roasted_sandwich - ToRoast

    Potato Veggie Mashed_Potato - vegetable
        
    wine milk water yogurt juice sweet_juice coke ice_tea - drink
        
    Laptop cup - obj
        
    mold cake - tobake

)


(:init
    
    (agent_at storeroom)
    (Human_at livingroom)
    (agent_near laundrybag storeroom)
    (human_near working_table livingroom)

    (agent_switched_off faucet sink Kitchen)  
    (agent_switched_off Burner_1 stove_burner_1 Kitchen) 
    (agent_switched_off Burner_2 stove_burner_2 Kitchen) 
    (agent_switched_off Burner_3 stove_burner_3 Kitchen) 
    (agent_switched_off Burner_4 stove_burner_4 Kitchen) 
    (agent_switched_off Oven_switch oven Kitchen) 
    (agent_switched_off WashingMachine_Switch WashingMachine Bathroom)
    
    (human_switched_off faucet sink Kitchen)  
    (human_switched_off Burner_1 stove_burner_1 Kitchen) 
    (human_switched_off Burner_2 stove_burner_2 Kitchen) 
    (human_switched_off Burner_3 stove_burner_3 Kitchen) 
    (human_switched_off Burner_4 stove_burner_4 Kitchen) 
    (human_switched_off Oven_switch oven Kitchen) 
    (human_switched_off WashingMachine_Switch WashingMachine Bathroom)


    (agent_switch_off Vacuum_Cleaner)
    (agent_switch_off extinguisher)
    (human_switch_off Vacuum_Cleaner)
    (human_switch_off extinguisher)

    
    (obj_at Faucet Kitchen)
    (obj_at burner_1 Kitchen)
    (obj_at burner_2 Kitchen)
    (obj_at burner_3 Kitchen)
    (obj_at burner_4 Kitchen)
    (obj_at Oven_switch Kitchen)
    (obj_at Dishwasher_Switch Kitchen)
    (obj_at extinguisher StoreRoom)
    (obj_at vacuum_cleaner StoreRoom)
    (obj_at DustMop Bathroom)
    (obj_at DustingCloth StoreRoom)
    (obj_at TV livingroom)
    (obj_at computer livingRoom)
    (obj_at musicplayer livingroom)

    (stuff_at Dirtydishes dining_Table Kitchen)

    (receptacle_at plate rack Kitchen)
    (receptacle_at glass cabinet Kitchen)
    (receptacle_at pan_1 shelf kitchen)
    (receptacle_at pan_2 shelf kitchen)
    (receptacle_at bowl cabinet kitchen)
    (receptacle_at metal_pot shelf kitchen)


    (not(open Oven Kitchen))
    (not(open Shelf Kitchen))

    ;Fruits and Vegetables
    (stuff_at Apple Fridge Kitchen)
    (equal Apple Sliced_Apple)
  
    (stuff_at Mango Fridge Kitchen)
    (equal Mango Sliced_Mango)

    (stuff_at Avocado Fridge Kitchen)
    (equal Avocado Sliced_Avocado)
    
    (stuff_at Veggie Fridge Kitchen) 
    (equal Veggie Veggie)

    (stuff_at Potato Fridge Kitchen) 
    (equal Potato Potato)

    ;Food items
    (stuff_at Pasta Cabinet Kitchen)
    (equal Pasta Cooked_Pasta)
    (cleaned Pasta)

    (stuff_at cereal Shelf Kitchen)
    (equal cereal Cooked_cereal)
    (cleaned cereal)

    (stuff_at Raw_eggs fridge Kitchen) ;ToBoil
    (equal Raw_eggs Boiled_eggs)
    (cleaned Raw_eggs)

    (stuff_at eggs fridge Kitchen) ;ToFry
    (equal eggs omelete)
    (equal eggs scrambled_eggs)
    (cleaned eggs)

    (stuff_at rice cabinet Kitchen)  ;ToBoil
    (equal rice Cooked_rice)
    (cleaned rice)

    (stuff_at lentil cabinet Kitchen) ;ToBoil
    (equal lentil Cooked_lentil)
    (cleaned lentil)

    (stuff_at soup cabinet Kitchen) ;ToBoil
    (equal soup prepared_soup)
    (cleaned soup)

    (stuff_at chicken fridge Kitchen) ;ToRoast
    (equal chicken roasted_chicken)
    (cleaned chicken)

    (stuff_at bread cabinet Kitchen)  ;ToRoast
    (equal bread roasted_sandwich)
    (Cleaned bread)

    (stuff_at cooked_Cereal fridge kitchen)


        
    (food_remaining)

    ;Baking items
    (stuff_at mold Shelf Kitchen)
    (equal mold cake)
 
     
    ;Drinking items
    (stuff_at wine Shelf Kitchen)
    (stuff_at milk Fridge Kitchen)
    (stuff_at water Fridge Kitchen)
    (stuff_at yogurt Fridge Kitchen)
    (stuff_at juice Fridge Kitchen)
    (stuff_at sweet_juice Fridge Kitchen)
    (stuff_at coke Fridge Kitchen)
    (stuff_at ice_tea fridge Kitchen)

    ;Pizza items
    (stuff_at pizza_base cabinet kitchen)
    (stuff_at Veggy Fridge Kitchen)
    (stuff_at Sauce Fridge Kitchen)
    (not(pizza_baked))
    (not(pizza_base_prepared))

    ;Washing
    (stuff_at Clothes LaundryBag Bathroom)

    (r_at Cabinet Kitchen)
    (r_at Rack Kitchen)
    (r_at Shelf Kitchen)
    (r_at stove_burner_1 Kitchen)
    (r_at stove_burner_2 Kitchen)
    (r_at stove_burner_3 Kitchen)
    (r_at stove_burner_4 Kitchen)
    (r_at Countertop Kitchen)
    (r_at Sink Kitchen)
    (r_at Oven Kitchen)
    (r_at Fridge Kitchen)
    (r_at Ironing_board LivingRoom)
    (r_at dining_table Kitchen)
    (r_at WashingMachine Bathroom)
    (r_at LaundryBag Storeroom)
    (r_at closet LivingRoom)
    (r_at Dustbin_1 Kitchen)
    (r_at working_table LivingRoom)



    
;; Duration between immobile receptacles
    
(=(dur Cabinet Cabinet)0)
(=(dur Cabinet Rack)13)
(=(dur Cabinet Shelf)47)
(=(dur Cabinet stove_burner_1)38)
(=(dur Cabinet stove_burner_2)39)
(=(dur Cabinet stove_burner_3)35)
(=(dur Cabinet stove_burner_4)37)
(=(dur Cabinet Countertop)28)
(=(dur Cabinet Sink)49)
(=(dur Cabinet Oven)46)
(=(dur Cabinet Fridge)37)
(=(dur Cabinet Ironing_board)98)
(=(dur Cabinet dining_table)34)
(=(dur Cabinet WashingMachine)1000)
(=(dur Cabinet LaundryBag)59)
(=(dur Cabinet closet)95)
(=(dur Cabinet Dustbin_1)62)
(=(dur Cabinet working_table)48)

(=(dur Rack Cabinet)13)
(=(dur Rack Rack)0)
(=(dur Rack Shelf)52)
(=(dur Rack stove_burner_1)32)
(=(dur Rack stove_burner_2)33)
(=(dur Rack stove_burner_3)29)
(=(dur Rack stove_burner_4)30)
(=(dur Rack Countertop)18)
(=(dur Rack Sink)43)
(=(dur Rack Oven)51)
(=(dur Rack Fridge)42)
(=(dur Rack Ironing_board)105)
(=(dur Rack dining_table)33)
(=(dur Rack WashingMachine)1000)
(=(dur Rack LaundryBag)55)
(=(dur Rack closet)104)
(=(dur Rack Dustbin_1)64)
(=(dur Rack working_table)56)

(=(dur Shelf Cabinet)47)
(=(dur Shelf Rack)52)
(=(dur Shelf Shelf)0)
(=(dur Shelf stove_burner_1)51)
(=(dur Shelf stove_burner_2)55)
(=(dur Shelf stove_burner_3)51)
(=(dur Shelf stove_burner_4)54)
(=(dur Shelf Countertop)54)
(=(dur Shelf Sink)52)
(=(dur Shelf Oven)5)
(=(dur Shelf Fridge)23)
(=(dur Shelf Ironing_board)57)
(=(dur Shelf dining_table)25)
(=(dur Shelf WashingMachine)1000)
(=(dur Shelf LaundryBag)52)
(=(dur Shelf closet)59)
(=(dur Shelf Dustbin_1)22)
(=(dur Shelf working_table)28)

(=(dur stove_burner_1 Cabinet)38)
(=(dur stove_burner_1 Rack)32)
(=(dur stove_burner_1 Shelf)51)
(=(dur stove_burner_1 stove_burner_1)0)
(=(dur stove_burner_1 stove_burner_2)3)
(=(dur stove_burner_1 stove_burner_3)2)
(=(dur stove_burner_1 stove_burner_4)4)
(=(dur stove_burner_1 Countertop)16)
(=(dur stove_burner_1 Sink)12)
(=(dur stove_burner_1 Oven)48)
(=(dur stove_burner_1 Fridge)55)
(=(dur stove_burner_1 Ironing_board)108)
(=(dur stove_burner_1 dining_table)27)
(=(dur stove_burner_1 WashingMachine)1000)
(=(dur stove_burner_1 LaundryBag)25)
(=(dur stove_burner_1 closet)111)
(=(dur stove_burner_1 Dustbin_1)51)
(=(dur stove_burner_1 working_table)70)

(=(dur stove_burner_2 Cabinet)39)
(=(dur stove_burner_2 Rack)33)
(=(dur stove_burner_2 Shelf)55)
(=(dur stove_burner_2 stove_burner_1)3)
(=(dur stove_burner_2 stove_burner_2)0)
(=(dur stove_burner_2 stove_burner_3)4)
(=(dur stove_burner_2 stove_burner_4)2)
(=(dur stove_burner_2 Countertop)15)
(=(dur stove_burner_2 Sink)13)
(=(dur stove_burner_2 Oven)51)
(=(dur stove_burner_2 Fridge)58)
(=(dur stove_burner_2 Ironing_board)112)
(=(dur stove_burner_2 dining_table)31)
(=(dur stove_burner_2 WashingMachine)1000)
(=(dur stove_burner_2 LaundryBag)26)
(=(dur stove_burner_2 closet)114)
(=(dur stove_burner_2 Dustbin_1)54)
(=(dur stove_burner_2 working_table)73)

(=(dur stove_burner_3 Cabinet)35)
(=(dur stove_burner_3 Rack)29)
(=(dur stove_burner_3 Shelf)51)
(=(dur stove_burner_3 stove_burner_1)2)
(=(dur stove_burner_3 stove_burner_2)4)
(=(dur stove_burner_3 stove_burner_3)0)
(=(dur stove_burner_3 stove_burner_4)3)
(=(dur stove_burner_3 Countertop)13)
(=(dur stove_burner_3 Sink)15)
(=(dur stove_burner_3 Oven)48)
(=(dur stove_burner_3 Fridge)53)
(=(dur stove_burner_3 Ironing_board)108)
(=(dur stove_burner_3 dining_table)27)
(=(dur stove_burner_3 WashingMachine)1000)
(=(dur stove_burner_3 LaundryBag)28)
(=(dur stove_burner_3 closet)110)
(=(dur stove_burner_3 Dustbin_1)52)
(=(dur stove_burner_3 working_table)68)

(=(dur stove_burner_4 Cabinet)37)
(=(dur stove_burner_4 Rack)30)
(=(dur stove_burner_4 Shelf)54)
(=(dur stove_burner_4 stove_burner_1)4)
(=(dur stove_burner_4 stove_burner_2)2)
(=(dur stove_burner_4 stove_burner_3)3)
(=(dur stove_burner_4 stove_burner_4)0)
(=(dur stove_burner_4 Countertop)13)
(=(dur stove_burner_4 Sink)16)
(=(dur stove_burner_4 Oven)51)
(=(dur stove_burner_4 Fridge)56)
(=(dur stove_burner_4 Ironing_board)111)
(=(dur stove_burner_4 dining_table)30)
(=(dur stove_burner_4 WashingMachine)1000)
(=(dur stove_burner_4 LaundryBag)29)
(=(dur stove_burner_4 closet)113)
(=(dur stove_burner_4 Dustbin_1)55)
(=(dur stove_burner_4 working_table)71)

(=(dur Countertop Cabinet)28)
(=(dur Countertop Rack)18)
(=(dur Countertop Shelf)54)
(=(dur Countertop stove_burner_1)16)
(=(dur Countertop stove_burner_2)15)
(=(dur Countertop stove_burner_3)13)
(=(dur Countertop stove_burner_4)13)
(=(dur Countertop Countertop)0)
(=(dur Countertop Sink)26)
(=(dur Countertop Oven)52)
(=(dur Countertop Fridge)51)
(=(dur Countertop Ironing_board)110)
(=(dur Countertop dining_table)30)
(=(dur Countertop WashingMachine)1000)
(=(dur Countertop LaundryBag)40)
(=(dur Countertop closet)111)
(=(dur Countertop Dustbin_1)59)
(=(dur Countertop working_table)66)

(=(dur Sink Cabinet)49)
(=(dur Sink Rack)43)
(=(dur Sink Shelf)52)
(=(dur Sink stove_burner_1)12)
(=(dur Sink stove_burner_2)13)
(=(dur Sink stove_burner_3)15)
(=(dur Sink stove_burner_4)16)
(=(dur Sink Countertop)26)
(=(dur Sink Sink)0)
(=(dur Sink Oven)48)
(=(dur Sink Fridge)59)
(=(dur Sink Ironing_board)107)
(=(dur Sink dining_table)29)
(=(dur Sink WashingMachine)1000)
(=(dur Sink LaundryBag)15)
(=(dur Sink closet)111)
(=(dur Sink Dustbin_1)46)
(=(dur Sink working_table)74)

(=(dur Oven Cabinet)46)
(=(dur Oven Rack)51)
(=(dur Oven Shelf)5)
(=(dur Oven stove_burner_1)48)
(=(dur Oven stove_burner_2)51)
(=(dur Oven stove_burner_3)48)
(=(dur Oven stove_burner_4)51)
(=(dur Oven Countertop)52)
(=(dur Oven Sink)48)
(=(dur Oven Oven)0)
(=(dur Oven Fridge)26)
(=(dur Oven Ironing_board)61)
(=(dur Oven dining_table)22)
(=(dur Oven WashingMachine)1000)
(=(dur Oven LaundryBag)47)
(=(dur Oven closet)63)
(=(dur Oven Dustbin_1)19)
(=(dur Oven working_table)33)

(=(dur Fridge Cabinet)37)
(=(dur Fridge Rack)42)
(=(dur Fridge Shelf)23)
(=(dur Fridge stove_burner_1)55)
(=(dur Fridge stove_burner_2)58)
(=(dur Fridge stove_burner_3)53)
(=(dur Fridge stove_burner_4)56)
(=(dur Fridge Countertop)51)
(=(dur Fridge Sink)57)
(=(dur Fridge Oven)26)
(=(dur Fridge Fridge)0)
(=(dur Fridge Ironing_board)64)
(=(dur Fridge dining_table)29)
(=(dur Fridge WashingMachine)1000)
(=(dur Fridge LaundryBag)64)
(=(dur Fridge closet)62)
(=(dur Fridge Dustbin_1)42)
(=(dur Fridge working_table)17)

(=(dur Ironing_board Cabinet)98)
(=(dur Ironing_board Rack)105)
(=(dur Ironing_board Shelf)57)
(=(dur Ironing_board stove_burner_1)108)
(=(dur Ironing_board stove_burner_2)112)
(=(dur Ironing_board stove_burner_3)108)
(=(dur Ironing_board stove_burner_4)111)
(=(dur Ironing_board Countertop)110)
(=(dur Ironing_board Sink)107)
(=(dur Ironing_board Oven)61)
(=(dur Ironing_board Fridge)64)
(=(dur Ironing_board Ironing_board)0)
(=(dur Ironing_board dining_table)81)
(=(dur Ironing_board WashingMachine)51)
(=(dur Ironing_board LaundryBag)1000)
(=(dur Ironing_board closet)15)
(=(dur Ironing_board Dustbin_1)63)
(=(dur Ironing_board working_table)52)

(=(dur dining_table Cabinet)34)
(=(dur dining_table Rack)33)
(=(dur dining_table Shelf)25)
(=(dur dining_table stove_burner_1)27)
(=(dur dining_table stove_burner_2)31)
(=(dur dining_table stove_burner_3)27)
(=(dur dining_table stove_burner_4)30)
(=(dur dining_table Countertop)30)
(=(dur dining_table Sink)29)
(=(dur dining_table Oven)22)
(=(dur dining_table Fridge)29)
(=(dur dining_table Ironing_board)81)
(=(dur dining_table dining_table)0)
(=(dur dining_table WashingMachine)1000)
(=(dur dining_table LaundryBag)35)
(=(dur dining_table closet)83)
(=(dur dining_table Dustbin_1)30)
(=(dur dining_table working_table)44)

(=(dur WashingMachine Cabinet)1000)
(=(dur WashingMachine Rack)1000)
(=(dur WashingMachine Shelf)1000)
(=(dur WashingMachine stove_burner_1)1000)
(=(dur WashingMachine stove_burner_2)1000)
(=(dur WashingMachine stove_burner_3)1000)
(=(dur WashingMachine stove_burner_4)1000)
(=(dur WashingMachine Countertop)1000)
(=(dur WashingMachine Sink)1000)
(=(dur WashingMachine Oven)1000)
(=(dur WashingMachine Fridge)1000)
(=(dur WashingMachine Ironing_board)51)
(=(dur WashingMachine dining_table)1000)
(=(dur WashingMachine WashingMachine)0)
(=(dur WashingMachine LaundryBag)1000)
(=(dur WashingMachine closet)61)
(=(dur WashingMachine Dustbin_1)1000)
(=(dur WashingMachine working_table)56)

(=(dur LaundryBag Cabinet)59)
(=(dur LaundryBag Rack)55)
(=(dur LaundryBag Shelf)52)
(=(dur LaundryBag stove_burner_1)25)
(=(dur LaundryBag stove_burner_2)26)
(=(dur LaundryBag stove_burner_3)28)
(=(dur LaundryBag stove_burner_4)29)
(=(dur LaundryBag Countertop)40)
(=(dur LaundryBag Sink)15)
(=(dur LaundryBag Oven)47)
(=(dur LaundryBag Fridge)64)
(=(dur LaundryBag Ironing_board)1000)
(=(dur LaundryBag dining_table)35)
(=(dur LaundryBag WashingMachine)1000)
(=(dur LaundryBag LaundryBag)0)
(=(dur LaundryBag closet)1000)
(=(dur LaundryBag Dustbin_1)41)
(=(dur LaundryBag working_table)1000)

(=(dur closet Cabinet)95)
(=(dur closet Rack)104)
(=(dur closet Shelf)59)
(=(dur closet stove_burner_1)111)
(=(dur closet stove_burner_2)114)
(=(dur closet stove_burner_3)110)
(=(dur closet stove_burner_4)113)
(=(dur closet Countertop)111)
(=(dur closet Sink)111)
(=(dur closet Oven)63)
(=(dur closet Fridge)62)
(=(dur closet Ironing_board)15)
(=(dur closet dining_table)83)
(=(dur closet WashingMachine)61)
(=(dur closet LaundryBag)1000)
(=(dur closet closet)0)
(=(dur closet Dustbin_1)70)
(=(dur closet working_table)48)

(=(dur Dustbin_1 Cabinet)62)
(=(dur Dustbin_1 Rack)64)
(=(dur Dustbin_1 Shelf)22)
(=(dur Dustbin_1 stove_burner_1)51)
(=(dur Dustbin_1 stove_burner_2)54)
(=(dur Dustbin_1 stove_burner_3)52)
(=(dur Dustbin_1 stove_burner_4)55)
(=(dur Dustbin_1 Countertop)59)
(=(dur Dustbin_1 Sink)46)
(=(dur Dustbin_1 Oven)19)
(=(dur Dustbin_1 Fridge)42)
(=(dur Dustbin_1 Ironing_board)63)
(=(dur Dustbin_1 dining_table)30)
(=(dur Dustbin_1 WashingMachine)1000)
(=(dur Dustbin_1 LaundryBag)41)
(=(dur Dustbin_1 closet)70)
(=(dur Dustbin_1 Dustbin_1)0)
(=(dur Dustbin_1 working_table)50)

(=(dur working_table Cabinet)48)
(=(dur working_table Rack)56)
(=(dur working_table Shelf)28)
(=(dur working_table stove_burner_1)70)
(=(dur working_table stove_burner_2)73)
(=(dur working_table stove_burner_3)68)
(=(dur working_table stove_burner_4)71)
(=(dur working_table Countertop)66)
(=(dur working_table Sink)74)
(=(dur working_table Oven)33)
(=(dur working_table Fridge)17)
(=(dur working_table Ironing_board)52)
(=(dur working_table dining_table)44)
(=(dur working_table WashingMachine)56)
(=(dur working_table LaundryBag)1000)
(=(dur working_table closet)48)
(=(dur working_table Dustbin_1)50)
(=(dur working_table working_table)0)

   

    ( = (total-cost) 0) 
     

)

(:goal
    (and
        

    
     (food_served cooked_Cereal plate dining_Table kitchen) ; use food in fridge to serve.


    ;  (food_served omelete bowl working_table livingRoom) ;lill off, I think there is a problem with served action here.
    ;  (egg_prepared omelete)


    )
)


(:metric minimize (total-cost))


)

;; TO DO

; Optimization



; Fix the picks_up_object action.
; Prepare medicines
;  (food_served omelete bowl working_table livingRoom) ;lill off, I think there is a problem with served action here.
;  (egg_prepared omelete)
; Charging items
; Add samosa
; Add fruit salad




