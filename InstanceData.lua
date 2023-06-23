local name, addon = ...;

addon.dungeons = {
    {
        name = DUNGEON_FLOOR_RAGEFIRE1,
        loreArtFileID = 608250,
        meta = {
            zone = "Orgrimmar",
            minLevel = 13,
            maxLevel = 18,
        },
        maps = {
            "Interface/Addons/Guildbook_ClassicEra/Icons/Maps/Dungeons/Ragefire",
        },
        bosses = {
            "Taragaman the Hungerer",
            "Oggleflint",
            "Jergosh the Invoker",
            "Bazzalan",
        },
        loot = {
            ["Taragaman the Hungerer"] = {
                14145,
                14148,
                14149,
                14540,
            },
            ["Oggleflint"] = {

            },
            ["Bazzalan"] = {

            },
            ["Jergosh the Invoker"] = {
                14151,
                14147,
                14150,
            },
        },
        history = "Ragefire Chasm consists of a network of volcanic caverns that lie below the orcs' new capital city of Orgrimmar. Recently, rumors have spread that a cult loyal to the demonic Shadow Council has taken up residence within the Chasm's fiery depths. This cult, known as the Burning Blade, threatens the very sovereignty of Durotar. Many believe that the orc Warchief, Thrall, is aware of the Blade's existence and has chosen not to destroy it in the hopes that its members might lead him straight to the Shadow Council. Either way, the dark powers emanating from Ragefire Chasm could undo all that the orcs have fought to attain.",
    },
    {
        name = DUNGEON_FLOOR_THEDEADMINES1,
        loreArtFileID = 526404,
        meta = {
            zone = "Westfall",
            minLevel = 15,
            maxLevel = 25,
        },
        maps = {
            "Interface/Addons/Guildbook_ClassicEra/Icons/Maps/Dungeons/TheDeadmines1",
            "Interface/Addons/Guildbook_ClassicEra/Icons/Maps/Dungeons/TheDeadmines2",
        },
        bosses = {
            "Rhahk'Zor",
            "Miner Johnson (Rare)",
            "Sneed's Shredder",
            "Gilnid",
            "Mr. Smite",
            "Captain Greenskin",
            "Edwin VanCleef",
            "Cookie (Bonus)",
        },
        loot = {
            ["Rhahk'Zor"] = {

            },
            ["Miner Johnson (Rare)"] = {

            },
        },
        history = "Once the greatest gold production center in the human lands, the Deadmines were abandoned when the Horde razed Stormwind city during the First War. Now the Defias Brotherhood has taken up residence and turned the dark tunnels into their private sanctum. It is rumored that the thieves have conscripted the clever goblins to help them build something terrible at the bottom of the mines - but what that may be is still uncertain. Rumor has it that the way into the Deadmines lies through the quiet, unassuming village of Moonbrook.",
    },
}