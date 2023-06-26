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
                5187,
                872,
            },
            ["Miner Johnson (Rare)"] = {
                5444,
                5443,
            },
            ["Sneed's Shredder"] = {
                2169,
                7365,
                1937,
            },
            ["Gilnid"] = {
                5199,
                1156,
            },
            ["Mr. Smite"] = {
                5192,
                5196,
                7230,
            },
            ["Captain Greenskin"] = {
                5201,
                5200,
                10403,
            },
            ["Edwin VanCleef"] = {
                2874,
                3637,
                5202,
                5193,
                5191,
                10399,
            },
            ["Cookie (Bonus)"] = {
                5197,
                5198,
                8490,
            }
        },
        history = "Once the greatest gold production center in the human lands, the Deadmines were abandoned when the Horde razed Stormwind city during the First War. Now the Defias Brotherhood has taken up residence and turned the dark tunnels into their private sanctum. It is rumored that the thieves have conscripted the clever goblins to help them build something terrible at the bottom of the mines - but what that may be is still uncertain. Rumor has it that the way into the Deadmines lies through the quiet, unassuming village of Moonbrook.",
    },
    {
        name = DUNGEON_FLOOR_WAILINGCAVERNS1,
        loreArtFileID = 608313,
        meta = {
            zone = "The Barrens",
            minLevel = 17,
            maxLevel = 27,
        },
        maps = {
            "Interface/Addons/Guildbook_ClassicEra/Icons/Maps/Dungeons/WailingCaverns",
        },
        bosses = {
            "Kresh",
            "Lady Anacondra",
            "Lord Cobrahn",
            "Deviate Faerie Dragon (Rare)",
            "Lord Pythas",
            "Skum",
            "Lord Serpentis",
            "Verdan the Everliving",
            "Mutanus the Devourer",
        },
        loot = {
            ["Kresh"] = {
                13245,
                6447,
            },
            ["Lady Anacondra"] = {

            },
            ["Lord Cobrahn"] = {
                
            },
            ["Deviate Faerie Dragon (Rare)"] = {
                
            },
            ["Lord Pythas"] = {
                
            },
            ["Skum"] = {
                
            },
            ["Lord Serpentis"] = {
                
            },
            ["Verdan the Everliving"] = {
                
            },
            ["Mutanus the Devourer"] = {
                
            },
        },
        history = "Recently, a night elf druid named Naralex discovered a network of underground caverns within the heart of the Barrens. Dubbed the 'Wailing Caverns', these natural caves were filled with steam fissures which produced long, mournful wails as they vented. Naralex believed he could use the caverns' underground springs to restore lushness and fertility to the Barrens - but to do so would require siphoning the energies of the fabled Emerald Dream. Once connected to the Dream, however, the druid's vision somehow became a nightmare. Soon the Wailing Caverns began to change - the waters turned foul and the once-docile creatures inside metamorphosed into vicious, deadly predators. It is said that Naralex himself still resides somewhere inside the heart of the labyrinth, trapped beyond the edges of the Emerald Dream. Even his former acolytes have been corrupted by their master's waking nightmare - transformed into the wicked Druids of the Fang.",
    },
}