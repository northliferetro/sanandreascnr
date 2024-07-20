import { Client, GatewayIntentBits, ChannelType } from 'discord.js';
import fs from 'fs';
import xml2js from 'xml-js';
import { MtaAPI } from 'mtasa-api'

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildPresences, GatewayIntentBits.GuildMembers] });

const TOKEN = 'MTI2MTI0MjQ4NzY2MjU3NTY4MA.G2Wqto.ZDO_cuIwK_2bh51O-_8pGJY_4eZENS8mC_tnTU';
const CHANNEL_NAME = 'server-updates';
const serverIP = "45.81.17.66"
const xmlPath = 'C:\\Program Files (x86)\\MTA San Andreas 1.6\\server\\mods\\deathmatch\\resources\\auth\\discord.xml';
let embedMessage;
let playersList;
let cnrMembers;

function readXmlFile(member) {
    try {
        const xmlData = fs.readFileSync(xmlPath, 'utf8');
        const jsonData = xml2js.xml2json(xmlData, { compact: true, spaces: 4 });
        const parsedData = JSON.parse(jsonData);

        const users = parsedData.users.user;

        if (Array.isArray(users)) {
            const foundUser = users.find(user => user._attributes.id === member.user.id);
            if (foundUser) {
                return foundUser._text || '0'; 
            }
        } else if (users._attributes) {
            if (users._attributes.id === member.user.id) {
                return users._text || '0'; 
            }
        }

        return '0'; 
    } catch (err) {
        console.error('Error reading or parsing xml file:', err);
        return '0'; 
    }
}

client.once('ready', async () => {
    console.log('Bot is online!');
    await setupChannels();
    trackPlayers();
    const api = new MtaAPI();
});

client.login(TOKEN);

async function setupChannels() {
    const guilds = await client.guilds.fetch();

    guilds.forEach(async guildData => {
        const guild = await guildData.fetch();
        console.log(`Checking guild: ${guild.name}`);

        const channel = guild.channels.cache.find(ch => ch.name === CHANNEL_NAME && ch.type === ChannelType.GuildText);

        if (channel) {
            console.log(`Found channel: ${channel.name} in guild: ${guild.name}`);

            let fetched;
            do {
                fetched = await channel.messages.fetch({ limit: 100 });
                if (fetched.size > 0) {
                    await channel.bulkDelete(fetched);
                    console.log(`Deleted ${fetched.size} messages in channel: ${channel.name}`);
                }
            } while (fetched.size >= 2);
            
            embedMessage = await channel.send({
                embeds: [{
                    title: 'San Andreas CnR - Ödül Tablosu',
                    description: 'Saatlik EXP ödülüne tâbi tutulan oyuncular:',
                    fields: []
                }]
            });

            console.log(`Sent embed message in channel: ${channel.name}`);
        } else {
            console.log(`Channel ${CHANNEL_NAME} not found in guild: ${guild.name}`);
        }
    });
}


function trackPlayers() {
    
    updateEmbed();

    setInterval(updateEmbed, 2000); 
    setInterval(updateScores, 3600000); 
}

async function updateScores() {
    try {
        cnrMembers.forEach(member => {
            const xmlData = fs.readFileSync(xmlPath, 'utf8');
            const parsedData = JSON.parse(xml2js.xml2json(xmlData, { compact: true, spaces: 4 }));
            const users = parsedData.users.user;

            if (Array.isArray(users)) {
                const foundUser = users.find(user => user._attributes.id === member.user.id);
                if (foundUser) {
                    foundUser._text = parseInt(foundUser._text) + 5; 
                }
            } else if (users._attributes) {
                if (users._attributes.id === member.user.id) {
                    users._text = parseInt(users._text) + 5; 
                }
            }

            const updatedXml = xml2js.json2xml(parsedData, { compact: true, spaces: 4 });

            fs.writeFileSync(xmlPath, updatedXml, 'utf8');
        });

        console.log('Scores updated successfully.');
    } catch (error) {
        console.error('Error updating scores:', error);
    }
}



async function updateEmbed() {
    let text = "Oyuncular"
    client.guilds.cache.forEach(guild => {
        guild.members.fetch().then(members => {
            cnrMembers = members.filter(member =>
            member.presence?.activities.some(activity => activity.state === 'San Andreas CnR')
             && readXmlFile(member));
            playersList = Array.from(cnrMembers.values()).map(member => `• ${member.user} - ${readXmlFile(member)} EXP`).join('\n') || 'N/A';
        });
    });
    if(cnrMembers && cnrMembers.size > 0) {
        text += ` (${cnrMembers.size})`;
    }
    const newEmbed = {
        title: 'San Andreas CnR - Ödül Tablosu',
        description: 'Saatlik EXP ödülüne tâbi tutulan oyuncular:',
        fields: [
            { name: text, value: playersList }
        ]
    };

    if (embedMessage) {
        await embedMessage.edit({ embeds: [newEmbed] });

    } else {
        console.log('Embed message not found.');
    }
}

client.on('disconnect', () => {
    cnrMembers.clear();
	updateEmbed();
});

client.on('destroy', () => {
    cnrMembers.clear();
	updateEmbed();
});