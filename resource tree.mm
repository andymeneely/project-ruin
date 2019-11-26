graph LR
    Energy   --1.5--> Soldier
    Energy   --2-->   Soldier
    Energy   --1.5--> Workers
    Energy   --2.3--> Workers
    Energy   --3-->   Cars
    Energy   --5-->   carfactory[CarFactory]
    carfactory --1--> Cars
    Cars     -.4.->   Energy
    Energy   --3-->   Linguist
    Energy   --3-->   Manager
    Energy   --3-->   Theologian
    Energy   --4-->   Officer
    Officer  --2-->   Destroyer
    Engineer --3-->   Destroyer
    Energy   --3-->   Destroyer
    Soldier  --1-->   Officer
    Energy   --3-->   Cruiser
    Engineer --6-->   Cruiser
    Officer  --4-->   Cruiser
    Destroyer -.3.->   Engineer
    Destroyer -.2.->   Officer
    Cruiser  -.6.->   Engineer
    Cruiser  -.4.->   Officer

    Destroyer -->      damage{{Damage Ship}}
    Cruiser   -->      damage{{Damage Ship}}
    Energy   --3-->   take{{Take Opportunity}}
    Energy   --1-->   move{{Move Opportunity}}
    Energy   -.5.->   more{{More Opportunities}}
    Energy   --2-->   spread{{Spread Energy}}
    Energy   --1-->   panic{{Decrease Panic}}
    Linguist --1-->   panic{{Decrease Panic}}
