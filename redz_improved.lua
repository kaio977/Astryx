--[[
	redz Library V5 - versão melhorada (Moon Hub)
	Principais correções/melhorias:
	  * Corrigido carregamento do tema salvo (VerifyTheme era usado antes de existir)
	  * Corrigido Funcs:ToggleVisible (não conseguia esconder) e Tab:Visible
	  * Corrigido SetTheme (quebrava em TextBox/ImageButton e não atualizava o fundo)
	  * Temas agora têm "Color Section" / "Color SubTitle" (antes só o Halloween tinha)
	  * Dropdown: removido hack de Create, corrigidos Add / Remove / Select / Set
	  * Slider: suporte a toque, não trava mais a criação (tween bloqueante) e dispara callback só quando muda
	  * TextBox: o valor padrão agora é aplicado
	  * Drag da janela mais suave e com suporte a toque
	  * Connection:Once agora funciona; callbacks substituíveis com :Set(function)
	  * Janela antiga é destruída corretamente ao recarregar o script
	  * Globais acidentais removidos (Bool, Wait, props, LabelHolder, SetSlider)
]]

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local redzlib = {
	Themes = {
		Halloween = {
			["Color Hub 1"] = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(13, 7, 11)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(24, 10, 16)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(13, 7, 11))
			}),
			["Color Hub 2"] = Color3.fromRGB(24, 10, 16),
			["Color Stroke"] = Color3.fromRGB(43, 13, 24),
			["Color Theme"] = Color3.fromRGB(139, 21, 56),
			["Color Text"] = Color3.fromRGB(255, 255, 255),
			["Color Dark Text"] = Color3.fromRGB(191, 166, 174),
			["Color Section"] = Color3.fromRGB(191, 166, 174),
			["Color SubTitle"] = Color3.fromRGB(170, 0, 0)
		},
		Darker = {
			["Color Hub 1"] = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
			}),
			["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
			["Color Stroke"] = Color3.fromRGB(40, 40, 40),
			["Color Theme"] = Color3.fromRGB(88, 101, 242),
			["Color Text"] = Color3.fromRGB(243, 243, 243),
			["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
		},
		Dark = {
			["Color Hub 1"] = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(47.5, 47.5, 47.5)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))
			}),
			["Color Hub 2"] = Color3.fromRGB(45, 45, 45),
			["Color Stroke"] = Color3.fromRGB(65, 65, 65),
			["Color Theme"] = Color3.fromRGB(65, 150, 255),
			["Color Text"] = Color3.fromRGB(245, 245, 245),
			["Color Dark Text"] = Color3.fromRGB(190, 190, 190)
		},
		Purple = {
			["Color Hub 1"] = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27.5, 25, 30)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(27.5, 25, 30))
			}),
			["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
			["Color Stroke"] = Color3.fromRGB(40, 40, 40),
			["Color Theme"] = Color3.fromRGB(179, 0, 255),
			["Color Text"] = Color3.fromRGB(240, 240, 240),
			["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
		}
	},
	Info = {
		Version = "1.2.0"
	},
	Save = {
		UISize = {550, 380},
		TabSize = 160,
		Theme = "Halloween"
	},
	Settings = {},
	Connection = {},
	Instances = {},
	Elements = {},
	Options = {},
	Flags = {},
	Tabs = {},
	Icons = (function()
		return {
			["accessibility"] = "rbxassetid://10709751939",
			["activity"] = "rbxassetid://10709752035",
			["airvent"] = "rbxassetid://10709752131",
			["airplay"] = "rbxassetid://10709752254",
			["alarmcheck"] = "rbxassetid://10709752405",
			["alarmclock"] = "rbxassetid://10709752630",
			["alarmclockoff"] = "rbxassetid://10709752508",
			["alarmminus"] = "rbxassetid://10709752732",
			["alarmplus"] = "rbxassetid://10709752825",
			["album"] = "rbxassetid://10709752906",
			["alertcircle"] = "rbxassetid://10709752996",
			["alertoctagon"] = "rbxassetid://10709753064",
			["alerttriangle"] = "rbxassetid://10709753149",
			["aligncenter"] = "rbxassetid://10709753570",
			["aligncenterhorizontal"] = "rbxassetid://10709753272",
			["aligncentervertical"] = "rbxassetid://10709753421",
			["alignendhorizontal"] = "rbxassetid://10709753692",
			["alignendvertical"] = "rbxassetid://10709753808",
			["alignhorizontaldistributecenter"] = "rbxassetid://10747779791",
			["alignhorizontaldistributeend"] = "rbxassetid://10747784534",
			["alignhorizontaldistributestart"] = "rbxassetid://10709754118",
			["alignhorizontaljustifycenter"] = "rbxassetid://10709754204",
			["alignhorizontaljustifyend"] = "rbxassetid://10709754317",
			["alignhorizontaljustifystart"] = "rbxassetid://10709754436",
			["alignhorizontalspacearound"] = "rbxassetid://10709754590",
			["alignhorizontalspacebetween"] = "rbxassetid://10709754749",
			["alignjustify"] = "rbxassetid://10709759610",
			["alignleft"] = "rbxassetid://10709759764",
			["alignright"] = "rbxassetid://10709759895",
			["alignstarthorizontal"] = "rbxassetid://10709760051",
			["alignstartvertical"] = "rbxassetid://10709760244",
			["alignverticaldistributecenter"] = "rbxassetid://10709760351",
			["alignverticaldistributeend"] = "rbxassetid://10709760434",
			["alignverticaldistributestart"] = "rbxassetid://10709760612",
			["alignverticaljustifycenter"] = "rbxassetid://10709760814",
			["alignverticaljustifyend"] = "rbxassetid://10709761003",
			["alignverticaljustifystart"] = "rbxassetid://10709761176",
			["alignverticalspacearound"] = "rbxassetid://10709761324",
			["alignverticalspacebetween"] = "rbxassetid://10709761434",
			["anchor"] = "rbxassetid://10709761530",
			["angry"] = "rbxassetid://10709761629",
			["annoyed"] = "rbxassetid://10709761722",
			["aperture"] = "rbxassetid://10709761813",
			["apple"] = "rbxassetid://10709761889",
			["archive"] = "rbxassetid://10709762233",
			["archiverestore"] = "rbxassetid://10709762058",
			["armchair"] = "rbxassetid://10709762327",
			["arrowbigdown"] = "rbxassetid://10747796644",
			["arrowbigleft"] = "rbxassetid://10709762574",
			["arrowbigright"] = "rbxassetid://10709762727",
			["arrowbigup"] = "rbxassetid://10709762879",
			["arrowdown"] = "rbxassetid://10709767827",
			["arrowdowncircle"] = "rbxassetid://10709763034",
			["arrowdownleft"] = "rbxassetid://10709767656",
			["arrowdownright"] = "rbxassetid://10709767750",
			["arrowleft"] = "rbxassetid://10709768114",
			["arrowleftcircle"] = "rbxassetid://10709767936",
			["arrowleftright"] = "rbxassetid://10709768019",
			["arrowright"] = "rbxassetid://10709768347",
			["arrowrightcircle"] = "rbxassetid://10709768226",
			["arrowup"] = "rbxassetid://10709768939",
			["arrowupcircle"] = "rbxassetid://10709768432",
			["arrowupdown"] = "rbxassetid://10709768538",
			["arrowupleft"] = "rbxassetid://10709768661",
			["arrowupright"] = "rbxassetid://10709768787",
			["asterisk"] = "rbxassetid://10709769095",
			["atsign"] = "rbxassetid://10709769286",
			["award"] = "rbxassetid://10709769406",
			["axe"] = "rbxassetid://10709769508",
			["axis3d"] = "rbxassetid://10709769598",
			["baby"] = "rbxassetid://10709769732",
			["backpack"] = "rbxassetid://10709769841",
			["baggageclaim"] = "rbxassetid://10709769935",
			["banana"] = "rbxassetid://10709770005",
			["banknote"] = "rbxassetid://10709770178",
			["barchart"] = "rbxassetid://10709773755",
			["barchart2"] = "rbxassetid://10709770317",
			["barchart3"] = "rbxassetid://10709770431",
			["barchart4"] = "rbxassetid://10709770560",
			["barcharthorizontal"] = "rbxassetid://10709773669",
			["barcode"] = "rbxassetid://10747360675",
			["baseline"] = "rbxassetid://10709773863",
			["bath"] = "rbxassetid://10709773963",
			["battery"] = "rbxassetid://10709774640",
			["batterycharging"] = "rbxassetid://10709774068",
			["batteryfull"] = "rbxassetid://10709774206",
			["batterylow"] = "rbxassetid://10709774370",
			["batterymedium"] = "rbxassetid://10709774513",
			["beaker"] = "rbxassetid://10709774756",
			["bed"] = "rbxassetid://10709775036",
			["beddouble"] = "rbxassetid://10709774864",
			["bedsingle"] = "rbxassetid://10709774968",
			["beer"] = "rbxassetid://10709775167",
			["bell"] = "rbxassetid://10709775704",
			["bellminus"] = "rbxassetid://10709775241",
			["belloff"] = "rbxassetid://10709775320",
			["bellplus"] = "rbxassetid://10709775448",
			["bellring"] = "rbxassetid://10709775560",
			["bike"] = "rbxassetid://10709775894",
			["binary"] = "rbxassetid://10709776050",
			["bitcoin"] = "rbxassetid://10709776126",
			["bluetooth"] = "rbxassetid://10709776655",
			["bluetoothconnected"] = "rbxassetid://10709776240",
			["bluetoothoff"] = "rbxassetid://10709776344",
			["bluetoothsearching"] = "rbxassetid://10709776501",
			["bold"] = "rbxassetid://10747813908",
			["bomb"] = "rbxassetid://10709781460",
			["bone"] = "rbxassetid://10709781605",
			["book"] = "rbxassetid://10709781824",
			["bookopen"] = "rbxassetid://10709781717",
			["bookmark"] = "rbxassetid://10709782154",
			["bookmarkminus"] = "rbxassetid://10709781919",
			["bookmarkplus"] = "rbxassetid://10709782044",
			["bot"] = "rbxassetid://10709782230",
			["box"] = "rbxassetid://10709782497",
			["boxselect"] = "rbxassetid://10709782342",
			["boxes"] = "rbxassetid://10709782582",
			["briefcase"] = "rbxassetid://10709782662",
			["brush"] = "rbxassetid://10709782758",
			["bug"] = "rbxassetid://10709782845",
			["building"] = "rbxassetid://10709783051",
			["building2"] = "rbxassetid://10709782939",
			["bus"] = "rbxassetid://10709783137",
			["cake"] = "rbxassetid://10709783217",
			["calculator"] = "rbxassetid://10709783311",
			["calendar"] = "rbxassetid://10709789505",
			["calendarcheck"] = "rbxassetid://10709783474",
			["calendarcheck2"] = "rbxassetid://10709783392",
			["calendarclock"] = "rbxassetid://10709783577",
			["calendardays"] = "rbxassetid://10709783673",
			["calendarheart"] = "rbxassetid://10709783835",
			["calendarminus"] = "rbxassetid://10709783959",
			["calendaroff"] = "rbxassetid://10709788784",
			["calendarplus"] = "rbxassetid://10709788937",
			["calendarrange"] = "rbxassetid://10709789053",
			["calendarsearch"] = "rbxassetid://10709789200",
			["calendarx"] = "rbxassetid://10709789407",
			["calendarx2"] = "rbxassetid://10709789329",
			["camera"] = "rbxassetid://10709789686",
			["cameraoff"] = "rbxassetid://10747822677",
			["car"] = "rbxassetid://10709789810",
			["carrot"] = "rbxassetid://10709789960",
			["cast"] = "rbxassetid://10709790097",
			["charge"] = "rbxassetid://10709790202",
			["check"] = "rbxassetid://10709790644",
			["checkcircle"] = "rbxassetid://10709790387",
			["checkcircle2"] = "rbxassetid://10709790298",
			["checksquare"] = "rbxassetid://10709790537",
			["chefhat"] = "rbxassetid://10709790757",
			["cherry"] = "rbxassetid://10709790875",
			["chevrondown"] = "rbxassetid://10709790948",
			["chevronfirst"] = "rbxassetid://10709791015",
			["chevronlast"] = "rbxassetid://10709791130",
			["chevronleft"] = "rbxassetid://10709791281",
			["chevronright"] = "rbxassetid://10709791437",
			["chevronup"] = "rbxassetid://10709791523",
			["chevronsdown"] = "rbxassetid://10709796864",
			["chevronsdownup"] = "rbxassetid://10709791632",
			["chevronsleft"] = "rbxassetid://10709797151",
			["chevronsleftright"] = "rbxassetid://10709797006",
			["chevronsright"] = "rbxassetid://10709797382",
			["chevronsrightleft"] = "rbxassetid://10709797274",
			["chevronsup"] = "rbxassetid://10709797622",
			["chevronsupdown"] = "rbxassetid://10709797508",
			["chrome"] = "rbxassetid://10709797725",
			["circle"] = "rbxassetid://10709798174",
			["circledot"] = "rbxassetid://10709797837",
			["circleellipsis"] = "rbxassetid://10709797985",
			["circleslashed"] = "rbxassetid://10709798100",
			["citrus"] = "rbxassetid://10709798276",
			["clapperboard"] = "rbxassetid://10709798350",
			["clipboard"] = "rbxassetid://10709799288",
			["clipboardcheck"] = "rbxassetid://10709798443",
			["clipboardcopy"] = "rbxassetid://10709798574",
			["clipboardedit"] = "rbxassetid://10709798682",
			["clipboardlist"] = "rbxassetid://10709798792",
			["clipboardsignature"] = "rbxassetid://10709798890",
			["clipboardtype"] = "rbxassetid://10709798999",
			["clipboardx"] = "rbxassetid://10709799124",
			["clock"] = "rbxassetid://10709805144",
			["clock1"] = "rbxassetid://10709799535",
			["clock10"] = "rbxassetid://10709799718",
			["clock11"] = "rbxassetid://10709799818",
			["clock12"] = "rbxassetid://10709799962",
			["clock2"] = "rbxassetid://10709803876",
			["clock3"] = "rbxassetid://10709803989",
			["clock4"] = "rbxassetid://10709804164",
			["clock5"] = "rbxassetid://10709804291",
			["clock6"] = "rbxassetid://10709804435",
			["clock7"] = "rbxassetid://10709804599",
			["clock8"] = "rbxassetid://10709804784",
			["clock9"] = "rbxassetid://10709804996",
			["cloud"] = "rbxassetid://10709806740",
			["cloudcog"] = "rbxassetid://10709805262",
			["clouddrizzle"] = "rbxassetid://10709805371",
			["cloudfog"] = "rbxassetid://10709805477",
			["cloudhail"] = "rbxassetid://10709805596",
			["cloudlightning"] = "rbxassetid://10709805727",
			["cloudmoon"] = "rbxassetid://10709805942",
			["cloudmoonrain"] = "rbxassetid://10709805838",
			["cloudoff"] = "rbxassetid://10709806060",
			["cloudrain"] = "rbxassetid://10709806277",
			["cloudrainwind"] = "rbxassetid://10709806166",
			["cloudsnow"] = "rbxassetid://10709806374",
			["cloudsun"] = "rbxassetid://10709806631",
			["cloudsunrain"] = "rbxassetid://10709806475",
			["cloudy"] = "rbxassetid://10709806859",
			["clover"] = "rbxassetid://10709806995",
			["code"] = "rbxassetid://10709810463",
			["code2"] = "rbxassetid://10709807111",
			["codepen"] = "rbxassetid://10709810534",
			["codesandbox"] = "rbxassetid://10709810676",
			["coffee"] = "rbxassetid://10709810814",
			["cog"] = "rbxassetid://10709810948",
			["coins"] = "rbxassetid://10709811110",
			["columns"] = "rbxassetid://10709811261",
			["command"] = "rbxassetid://10709811365",
			["compass"] = "rbxassetid://10709811445",
			["component"] = "rbxassetid://10709811595",
			["conciergebell"] = "rbxassetid://10709811706",
			["connection"] = "rbxassetid://10747361219",
			["contact"] = "rbxassetid://10709811834",
			["contrast"] = "rbxassetid://10709811939",
			["cookie"] = "rbxassetid://10709812067",
			["copy"] = "rbxassetid://10709812159",
			["copyleft"] = "rbxassetid://10709812251",
			["copyright"] = "rbxassetid://10709812311",
			["cornerdownleft"] = "rbxassetid://10709812396",
			["cornerdownright"] = "rbxassetid://10709812485",
			["cornerleftdown"] = "rbxassetid://10709812632",
			["cornerleftup"] = "rbxassetid://10709812784",
			["cornerrightdown"] = "rbxassetid://10709812939",
			["cornerrightup"] = "rbxassetid://10709813094",
			["cornerupleft"] = "rbxassetid://10709813185",
			["cornerupright"] = "rbxassetid://10709813281",
			["cpu"] = "rbxassetid://10709813383",
			["croissant"] = "rbxassetid://10709818125",
			["crop"] = "rbxassetid://10709818245",
			["cross"] = "rbxassetid://10709818399",
			["crosshair"] = "rbxassetid://10709818534",
			["crown"] = "rbxassetid://10709818626",
			["cupsoda"] = "rbxassetid://10709818763",
			["curlybraces"] = "rbxassetid://10709818847",
			["currency"] = "rbxassetid://10709818931",
			["database"] = "rbxassetid://10709818996",
			["delete"] = "rbxassetid://10709819059",
			["diamond"] = "rbxassetid://10709819149",
			["dice1"] = "rbxassetid://10709819266",
			["dice2"] = "rbxassetid://10709819361",
			["dice3"] = "rbxassetid://10709819508",
			["dice4"] = "rbxassetid://10709819670",
			["dice5"] = "rbxassetid://10709819801",
			["dice6"] = "rbxassetid://10709819896",
			["dices"] = "rbxassetid://10723343321",
			["diff"] = "rbxassetid://10723343416",
			["disc"] = "rbxassetid://10723343537",
			["divide"] = "rbxassetid://10723343805",
			["dividecircle"] = "rbxassetid://10723343636",
			["dividesquare"] = "rbxassetid://10723343737",
			["dollarsign"] = "rbxassetid://10723343958",
			["download"] = "rbxassetid://10723344270",
			["downloadcloud"] = "rbxassetid://10723344088",
			["droplet"] = "rbxassetid://10723344432",
			["droplets"] = "rbxassetid://10734883356",
			["drumstick"] = "rbxassetid://10723344737",
			["edit"] = "rbxassetid://10734883598",
			["edit2"] = "rbxassetid://10723344885",
			["edit3"] = "rbxassetid://10723345088",
			["egg"] = "rbxassetid://10723345518",
			["eggfried"] = "rbxassetid://10723345347",
			["electricity"] = "rbxassetid://10723345749",
			["electricityoff"] = "rbxassetid://10723345643",
			["equal"] = "rbxassetid://10723345990",
			["equalnot"] = "rbxassetid://10723345866",
			["eraser"] = "rbxassetid://10723346158",
			["euro"] = "rbxassetid://10723346372",
			["expand"] = "rbxassetid://10723346553",
			["externallink"] = "rbxassetid://10723346684",
			["eye"] = "rbxassetid://10723346959",
			["eyeoff"] = "rbxassetid://10723346871",
			["factory"] = "rbxassetid://10723347051",
			["fan"] = "rbxassetid://10723354359",
			["fastforward"] = "rbxassetid://10723354521",
			["feather"] = "rbxassetid://10723354671",
			["figma"] = "rbxassetid://10723354801",
			["file"] = "rbxassetid://10723374641",
			["filearchive"] = "rbxassetid://10723354921",
			["fileaudio"] = "rbxassetid://10723355148",
			["fileaudio2"] = "rbxassetid://10723355026",
			["fileaxis3d"] = "rbxassetid://10723355272",
			["filebadge"] = "rbxassetid://10723355622",
			["filebadge2"] = "rbxassetid://10723355451",
			["filebarchart"] = "rbxassetid://10723355887",
			["filebarchart2"] = "rbxassetid://10723355746",
			["filebox"] = "rbxassetid://10723355989",
			["filecheck"] = "rbxassetid://10723356210",
			["filecheck2"] = "rbxassetid://10723356100",
			["fileclock"] = "rbxassetid://10723356329",
			["filecode"] = "rbxassetid://10723356507",
			["filecog"] = "rbxassetid://10723356830",
			["filecog2"] = "rbxassetid://10723356676",
			["filediff"] = "rbxassetid://10723357039",
			["filedigit"] = "rbxassetid://10723357151",
			["filedown"] = "rbxassetid://10723357322",
			["fileedit"] = "rbxassetid://10723357495",
			["fileheart"] = "rbxassetid://10723357637",
			["fileimage"] = "rbxassetid://10723357790",
			["fileinput"] = "rbxassetid://10723357933",
			["filejson"] = "rbxassetid://10723364435",
			["filejson2"] = "rbxassetid://10723364361",
			["filekey"] = "rbxassetid://10723364605",
			["filekey2"] = "rbxassetid://10723364515",
			["filelinechart"] = "rbxassetid://10723364725",
			["filelock"] = "rbxassetid://10723364957",
			["filelock2"] = "rbxassetid://10723364861",
			["fileminus"] = "rbxassetid://10723365254",
			["fileminus2"] = "rbxassetid://10723365086",
			["fileoutput"] = "rbxassetid://10723365457",
			["filepiechart"] = "rbxassetid://10723365598",
			["fileplus"] = "rbxassetid://10723365877",
			["fileplus2"] = "rbxassetid://10723365766",
			["filequestion"] = "rbxassetid://10723365987",
			["filescan"] = "rbxassetid://10723366167",
			["filesearch"] = "rbxassetid://10723366550",
			["filesearch2"] = "rbxassetid://10723366340",
			["filesignature"] = "rbxassetid://10723366741",
			["filespreadsheet"] = "rbxassetid://10723366962",
			["filesymlink"] = "rbxassetid://10723367098",
			["fileterminal"] = "rbxassetid://10723367244",
			["filetext"] = "rbxassetid://10723367380",
			["filetype"] = "rbxassetid://10723367606",
			["filetype2"] = "rbxassetid://10723367509",
			["fileup"] = "rbxassetid://10723367734",
			["filevideo"] = "rbxassetid://10723373884",
			["filevideo2"] = "rbxassetid://10723367834",
			["filevolume"] = "rbxassetid://10723374172",
			["filevolume2"] = "rbxassetid://10723374030",
			["filewarning"] = "rbxassetid://10723374276",
			["filex"] = "rbxassetid://10723374544",
			["filex2"] = "rbxassetid://10723374378",
			["files"] = "rbxassetid://10723374759",
			["film"] = "rbxassetid://10723374981",
			["filter"] = "rbxassetid://10723375128",
			["fingerprint"] = "rbxassetid://10723375250",
			["flag"] = "rbxassetid://10723375890",
			["flagoff"] = "rbxassetid://10723375443",
			["flagtriangleleft"] = "rbxassetid://10723375608",
			["flagtriangleright"] = "rbxassetid://10723375727",
			["flame"] = "rbxassetid://10723376114",
			["flashlight"] = "rbxassetid://10723376471",
			["flashlightoff"] = "rbxassetid://10723376365",
			["flaskconical"] = "rbxassetid://10734883986",
			["flaskround"] = "rbxassetid://10723376614",
			["fliphorizontal"] = "rbxassetid://10723376884",
			["fliphorizontal2"] = "rbxassetid://10723376745",
			["flipvertical"] = "rbxassetid://10723377138",
			["flipvertical2"] = "rbxassetid://10723377026",
			["flower"] = "rbxassetid://10747830374",
			["flower2"] = "rbxassetid://10723377305",
			["focus"] = "rbxassetid://10723377537",
			["folder"] = "rbxassetid://10723387563",
			["folderarchive"] = "rbxassetid://10723384478",
			["foldercheck"] = "rbxassetid://10723384605",
			["folderclock"] = "rbxassetid://10723384731",
			["folderclosed"] = "rbxassetid://10723384893",
			["foldercog"] = "rbxassetid://10723385213",
			["foldercog2"] = "rbxassetid://10723385036",
			["folderdown"] = "rbxassetid://10723385338",
			["folderedit"] = "rbxassetid://10723385445",
			["folderheart"] = "rbxassetid://10723385545",
			["folderinput"] = "rbxassetid://10723385721",
			["folderkey"] = "rbxassetid://10723385848",
			["folderlock"] = "rbxassetid://10723386005",
			["folderminus"] = "rbxassetid://10723386127",
			["folderopen"] = "rbxassetid://10723386277",
			["folderoutput"] = "rbxassetid://10723386386",
			["folderplus"] = "rbxassetid://10723386531",
			["foldersearch"] = "rbxassetid://10723386787",
			["foldersearch2"] = "rbxassetid://10723386674",
			["foldersymlink"] = "rbxassetid://10723386930",
			["foldertree"] = "rbxassetid://10723387085",
			["folderup"] = "rbxassetid://10723387265",
			["folderx"] = "rbxassetid://10723387448",
			["folders"] = "rbxassetid://10723387721",
			["forminput"] = "rbxassetid://10723387841",
			["forward"] = "rbxassetid://10723388016",
			["frame"] = "rbxassetid://10723394389",
			["framer"] = "rbxassetid://10723394565",
			["frown"] = "rbxassetid://10723394681",
			["fuel"] = "rbxassetid://10723394846",
			["functionsquare"] = "rbxassetid://10723395041",
			["gamepad"] = "rbxassetid://10723395457",
			["gamepad2"] = "rbxassetid://10723395215",
			["gauge"] = "rbxassetid://10723395708",
			["gavel"] = "rbxassetid://10723395896",
			["gem"] = "rbxassetid://10723396000",
			["ghost"] = "rbxassetid://10723396107",
			["gift"] = "rbxassetid://10723396402",
			["giftcard"] = "rbxassetid://10723396225",
			["gitbranch"] = "rbxassetid://10723396676",
			["gitbranchplus"] = "rbxassetid://10723396542",
			["gitcommit"] = "rbxassetid://10723396812",
			["gitcompare"] = "rbxassetid://10723396954",
			["gitfork"] = "rbxassetid://10723397049",
			["gitmerge"] = "rbxassetid://10723397165",
			["gitpullrequest"] = "rbxassetid://10723397431",
			["gitpullrequestclosed"] = "rbxassetid://10723397268",
			["gitpullrequestdraft"] = "rbxassetid://10734884302",
			["glass"] = "rbxassetid://10723397788",
			["glass2"] = "rbxassetid://10723397529",
			["glasswater"] = "rbxassetid://10723397678",
			["glasses"] = "rbxassetid://10723397895",
			["globe"] = "rbxassetid://10723404337",
			["globe2"] = "rbxassetid://10723398002",
			["grab"] = "rbxassetid://10723404472",
			["graduationcap"] = "rbxassetid://10723404691",
			["grape"] = "rbxassetid://10723404822",
			["grid"] = "rbxassetid://10723404936",
			["griphorizontal"] = "rbxassetid://10723405089",
			["gripvertical"] = "rbxassetid://10723405236",
			["hammer"] = "rbxassetid://10723405360",
			["hand"] = "rbxassetid://10723405649",
			["handmetal"] = "rbxassetid://10723405508",
			["harddrive"] = "rbxassetid://10723405749",
			["hardhat"] = "rbxassetid://10723405859",
			["hash"] = "rbxassetid://10723405975",
			["haze"] = "rbxassetid://10723406078",
			["headphones"] = "rbxassetid://10723406165",
			["heart"] = "rbxassetid://10723406885",
			["heartcrack"] = "rbxassetid://10723406299",
			["hearthandshake"] = "rbxassetid://10723406480",
			["heartoff"] = "rbxassetid://10723406662",
			["heartpulse"] = "rbxassetid://10723406795",
			["helpcircle"] = "rbxassetid://10723406988",
			["hexagon"] = "rbxassetid://10723407092",
			["highlighter"] = "rbxassetid://10723407192",
			["history"] = "rbxassetid://10723407335",
			["home"] = "rbxassetid://10723407389",
			["hourglass"] = "rbxassetid://10723407498",
			["icecream"] = "rbxassetid://10723414308",
			["image"] = "rbxassetid://10723415040",
			["imageminus"] = "rbxassetid://10723414487",
			["imageoff"] = "rbxassetid://10723414677",
			["imageplus"] = "rbxassetid://10723414827",
			["import"] = "rbxassetid://10723415205",
			["inbox"] = "rbxassetid://10723415335",
			["indent"] = "rbxassetid://10723415494",
			["indianrupee"] = "rbxassetid://10723415642",
			["infinity"] = "rbxassetid://10723415766",
			["info"] = "rbxassetid://10723415903",
			["inspect"] = "rbxassetid://10723416057",
			["italic"] = "rbxassetid://10723416195",
			["japaneseyen"] = "rbxassetid://10723416363",
			["joystick"] = "rbxassetid://10723416527",
			["key"] = "rbxassetid://10723416652",
			["keyboard"] = "rbxassetid://10723416765",
			["lamp"] = "rbxassetid://10723417513",
			["lampceiling"] = "rbxassetid://10723416922",
			["lampdesk"] = "rbxassetid://10723417016",
			["lampfloor"] = "rbxassetid://10723417131",
			["lampwalldown"] = "rbxassetid://10723417240",
			["lampwallup"] = "rbxassetid://10723417356",
			["landmark"] = "rbxassetid://10723417608",
			["languages"] = "rbxassetid://10723417703",
			["laptop"] = "rbxassetid://10723423881",
			["laptop2"] = "rbxassetid://10723417797",
			["lasso"] = "rbxassetid://10723424235",
			["lassoselect"] = "rbxassetid://10723424058",
			["laugh"] = "rbxassetid://10723424372",
			["layers"] = "rbxassetid://10723424505",
			["layout"] = "rbxassetid://10723425376",
			["layoutdashboard"] = "rbxassetid://10723424646",
			["layoutgrid"] = "rbxassetid://10723424838",
			["layoutlist"] = "rbxassetid://10723424963",
			["layouttemplate"] = "rbxassetid://10723425187",
			["leaf"] = "rbxassetid://10723425539",
			["library"] = "rbxassetid://10723425615",
			["lifebuoy"] = "rbxassetid://10723425685",
			["lightbulb"] = "rbxassetid://10723425852",
			["lightbulboff"] = "rbxassetid://10723425762",
			["linechart"] = "rbxassetid://10723426393",
			["link"] = "rbxassetid://10723426722",
			["link2"] = "rbxassetid://10723426595",
			["link2off"] = "rbxassetid://10723426513",
			["list"] = "rbxassetid://10723433811",
			["listchecks"] = "rbxassetid://10734884548",
			["listend"] = "rbxassetid://10723426886",
			["listminus"] = "rbxassetid://10723426986",
			["listmusic"] = "rbxassetid://10723427081",
			["listordered"] = "rbxassetid://10723427199",
			["listplus"] = "rbxassetid://10723427334",
			["liststart"] = "rbxassetid://10723427494",
			["listvideo"] = "rbxassetid://10723427619",
			["listx"] = "rbxassetid://10723433655",
			["loader"] = "rbxassetid://10723434070",
			["loader2"] = "rbxassetid://10723433935",
			["locate"] = "rbxassetid://10723434557",
			["locatefixed"] = "rbxassetid://10723434236",
			["locateoff"] = "rbxassetid://10723434379",
			["lock"] = "rbxassetid://10723434711",
			["login"] = "rbxassetid://10723434830",
			["logout"] = "rbxassetid://10723434906",
			["luggage"] = "rbxassetid://10723434993",
			["magnet"] = "rbxassetid://10723435069",
			["mail"] = "rbxassetid://10734885430",
			["mailcheck"] = "rbxassetid://10723435182",
			["mailminus"] = "rbxassetid://10723435261",
			["mailopen"] = "rbxassetid://10723435342",
			["mailplus"] = "rbxassetid://10723435443",
			["mailquestion"] = "rbxassetid://10723435515",
			["mailsearch"] = "rbxassetid://10734884739",
			["mailwarning"] = "rbxassetid://10734885015",
			["mailx"] = "rbxassetid://10734885247",
			["mails"] = "rbxassetid://10734885614",
			["map"] = "rbxassetid://10734886202",
			["mappin"] = "rbxassetid://10734886004",
			["mappinoff"] = "rbxassetid://10734885803",
			["maximize"] = "rbxassetid://10734886735",
			["maximize2"] = "rbxassetid://10734886496",
			["medal"] = "rbxassetid://10734887072",
			["megaphone"] = "rbxassetid://10734887454",
			["megaphoneoff"] = "rbxassetid://10734887311",
			["meh"] = "rbxassetid://10734887603",
			["menu"] = "rbxassetid://10734887784",
			["messagecircle"] = "rbxassetid://10734888000",
			["messagesquare"] = "rbxassetid://10734888228",
			["mic"] = "rbxassetid://10734888864",
			["mic2"] = "rbxassetid://10734888430",
			["micoff"] = "rbxassetid://10734888646",
			["microscope"] = "rbxassetid://10734889106",
			["microwave"] = "rbxassetid://10734895076",
			["milestone"] = "rbxassetid://10734895310",
			["minimize"] = "rbxassetid://10734895698",
			["minimize2"] = "rbxassetid://10734895530",
			["minus"] = "rbxassetid://10734896206",
			["minuscircle"] = "rbxassetid://10734895856",
			["minussquare"] = "rbxassetid://10734896029",
			["monitor"] = "rbxassetid://10734896881",
			["monitoroff"] = "rbxassetid://10734896360",
			["monitorspeaker"] = "rbxassetid://10734896512",
			["moon"] = "rbxassetid://10734897102",
			["morehorizontal"] = "rbxassetid://10734897250",
			["morevertical"] = "rbxassetid://10734897387",
			["mountain"] = "rbxassetid://10734897956",
			["mountainsnow"] = "rbxassetid://10734897665",
			["mouse"] = "rbxassetid://10734898592",
			["mousepointer"] = "rbxassetid://10734898476",
			["mousepointer2"] = "rbxassetid://10734898194",
			["mousepointerclick"] = "rbxassetid://10734898355",
			["move"] = "rbxassetid://10734900011",
			["move3d"] = "rbxassetid://10734898756",
			["movediagonal"] = "rbxassetid://10734899164",
			["movediagonal2"] = "rbxassetid://10734898934",
			["movehorizontal"] = "rbxassetid://10734899414",
			["movevertical"] = "rbxassetid://10734899821",
			["music"] = "rbxassetid://10734905958",
			["music2"] = "rbxassetid://10734900215",
			["music3"] = "rbxassetid://10734905665",
			["music4"] = "rbxassetid://10734905823",
			["navigation"] = "rbxassetid://10734906744",
			["navigation2"] = "rbxassetid://10734906332",
			["navigation2off"] = "rbxassetid://10734906144",
			["navigationoff"] = "rbxassetid://10734906580",
			["network"] = "rbxassetid://10734906975",
			["newspaper"] = "rbxassetid://10734907168",
			["octagon"] = "rbxassetid://10734907361",
			["option"] = "rbxassetid://10734907649",
			["outdent"] = "rbxassetid://10734907933",
			["package"] = "rbxassetid://10734909540",
			["package2"] = "rbxassetid://10734908151",
			["packagecheck"] = "rbxassetid://10734908384",
			["packageminus"] = "rbxassetid://10734908626",
			["packageopen"] = "rbxassetid://10734908793",
			["packageplus"] = "rbxassetid://10734909016",
			["packagesearch"] = "rbxassetid://10734909196",
			["packagex"] = "rbxassetid://10734909375",
			["paintbucket"] = "rbxassetid://10734909847",
			["paintbrush"] = "rbxassetid://10734910187",
			["paintbrush2"] = "rbxassetid://10734910030",
			["palette"] = "rbxassetid://10734910430",
			["palmtree"] = "rbxassetid://10734910680",
			["paperclip"] = "rbxassetid://10734910927",
			["partypopper"] = "rbxassetid://10734918735",
			["pause"] = "rbxassetid://10734919336",
			["pausecircle"] = "rbxassetid://10735024209",
			["pauseoctagon"] = "rbxassetid://10734919143",
			["pentool"] = "rbxassetid://10734919503",
			["pencil"] = "rbxassetid://10734919691",
			["percent"] = "rbxassetid://10734919919",
			["personstanding"] = "rbxassetid://10734920149",
			["phone"] = "rbxassetid://10734921524",
			["phonecall"] = "rbxassetid://10734920305",
			["phoneforwarded"] = "rbxassetid://10734920508",
			["phoneincoming"] = "rbxassetid://10734920694",
			["phonemissed"] = "rbxassetid://10734920845",
			["phoneoff"] = "rbxassetid://10734921077",
			["phoneoutgoing"] = "rbxassetid://10734921288",
			["piechart"] = "rbxassetid://10734921727",
			["piggybank"] = "rbxassetid://10734921935",
			["pin"] = "rbxassetid://10734922324",
			["pinoff"] = "rbxassetid://10734922180",
			["pipette"] = "rbxassetid://10734922497",
			["pizza"] = "rbxassetid://10734922774",
			["plane"] = "rbxassetid://10734922971",
			["play"] = "rbxassetid://10734923549",
			["playcircle"] = "rbxassetid://10734923214",
			["plus"] = "rbxassetid://10734924532",
			["pluscircle"] = "rbxassetid://10734923868",
			["plussquare"] = "rbxassetid://10734924219",
			["podcast"] = "rbxassetid://10734929553",
			["pointer"] = "rbxassetid://10734929723",
			["poundsterling"] = "rbxassetid://10734929981",
			["power"] = "rbxassetid://10734930466",
			["poweroff"] = "rbxassetid://10734930257",
			["printer"] = "rbxassetid://10734930632",
			["puzzle"] = "rbxassetid://10734930886",
			["quote"] = "rbxassetid://10734931234",
			["radio"] = "rbxassetid://10734931596",
			["radioreceiver"] = "rbxassetid://10734931402",
			["rectanglehorizontal"] = "rbxassetid://10734931777",
			["rectanglevertical"] = "rbxassetid://10734932081",
			["recycle"] = "rbxassetid://10734932295",
			["redo"] = "rbxassetid://10734932822",
			["redo2"] = "rbxassetid://10734932586",
			["refreshccw"] = "rbxassetid://10734933056",
			["refreshcw"] = "rbxassetid://10734933222",
			["refrigerator"] = "rbxassetid://10734933465",
			["regex"] = "rbxassetid://10734933655",
			["repeat"] = "rbxassetid://10734933966",
			["repeat1"] = "rbxassetid://10734933826",
			["reply"] = "rbxassetid://10734934252",
			["replyall"] = "rbxassetid://10734934132",
			["rewind"] = "rbxassetid://10734934347",
			["rocket"] = "rbxassetid://10734934585",
			["rockingchair"] = "rbxassetid://10734939942",
			["rotate3d"] = "rbxassetid://10734940107",
			["rotateccw"] = "rbxassetid://10734940376",
			["rotatecw"] = "rbxassetid://10734940654",
			["rss"] = "rbxassetid://10734940825",
			["ruler"] = "rbxassetid://10734941018",
			["russianruble"] = "rbxassetid://10734941199",
			["sailboat"] = "rbxassetid://10734941354",
			["save"] = "rbxassetid://10734941499",
			["scale"] = "rbxassetid://10734941912",
			["scale3d"] = "rbxassetid://10734941739",
			["scaling"] = "rbxassetid://10734942072",
			["scan"] = "rbxassetid://10734942565",
			["scanface"] = "rbxassetid://10734942198",
			["scanline"] = "rbxassetid://10734942351",
			["scissors"] = "rbxassetid://10734942778",
			["screenshare"] = "rbxassetid://10734943193",
			["screenshareoff"] = "rbxassetid://10734942967",
			["scroll"] = "rbxassetid://10734943448",
			["search"] = "rbxassetid://10734943674",
			["send"] = "rbxassetid://10734943902",
			["separatorhorizontal"] = "rbxassetid://10734944115",
			["separatorvertical"] = "rbxassetid://10734944326",
			["server"] = "rbxassetid://10734949856",
			["servercog"] = "rbxassetid://10734944444",
			["servercrash"] = "rbxassetid://10734944554",
			["serveroff"] = "rbxassetid://10734944668",
			["settings"] = "rbxassetid://10734950309",
			["settings2"] = "rbxassetid://10734950020",
			["share"] = "rbxassetid://10734950813",
			["share2"] = "rbxassetid://10734950553",
			["sheet"] = "rbxassetid://10734951038",
			["shield"] = "rbxassetid://10734951847",
			["shieldalert"] = "rbxassetid://10734951173",
			["shieldcheck"] = "rbxassetid://10734951367",
			["shieldclose"] = "rbxassetid://10734951535",
			["shieldoff"] = "rbxassetid://10734951684",
			["shirt"] = "rbxassetid://10734952036",
			["shoppingbag"] = "rbxassetid://10734952273",
			["shoppingcart"] = "rbxassetid://10734952479",
			["shovel"] = "rbxassetid://10734952773",
			["showerhead"] = "rbxassetid://10734952942",
			["shrink"] = "rbxassetid://10734953073",
			["shrub"] = "rbxassetid://10734953241",
			["shuffle"] = "rbxassetid://10734953451",
			["sidebar"] = "rbxassetid://10734954301",
			["sidebarclose"] = "rbxassetid://10734953715",
			["sidebaropen"] = "rbxassetid://10734954000",
			["sigma"] = "rbxassetid://10734954538",
			["signal"] = "rbxassetid://10734961133",
			["signalhigh"] = "rbxassetid://10734954807",
			["signallow"] = "rbxassetid://10734955080",
			["signalmedium"] = "rbxassetid://10734955336",
			["signalzero"] = "rbxassetid://10734960878",
			["siren"] = "rbxassetid://10734961284",
			["skipback"] = "rbxassetid://10734961526",
			["skipforward"] = "rbxassetid://10734961809",
			["skull"] = "rbxassetid://10734962068",
			["slack"] = "rbxassetid://10734962339",
			["slash"] = "rbxassetid://10734962600",
			["slice"] = "rbxassetid://10734963024",
			["sliders"] = "rbxassetid://10734963400",
			["slidershorizontal"] = "rbxassetid://10734963191",
			["smartphone"] = "rbxassetid://10734963940",
			["smartphonecharging"] = "rbxassetid://10734963671",
			["smile"] = "rbxassetid://10734964441",
			["smileplus"] = "rbxassetid://10734964188",
			["snowflake"] = "rbxassetid://10734964600",
			["sofa"] = "rbxassetid://10734964852",
			["sortasc"] = "rbxassetid://10734965115",
			["sortdesc"] = "rbxassetid://10734965287",
			["speaker"] = "rbxassetid://10734965419",
			["sprout"] = "rbxassetid://10734965572",
			["square"] = "rbxassetid://10734965702",
			["star"] = "rbxassetid://10734966248",
			["starhalf"] = "rbxassetid://10734965897",
			["staroff"] = "rbxassetid://10734966097",
			["stethoscope"] = "rbxassetid://10734966384",
			["sticker"] = "rbxassetid://10734972234",
			["stickynote"] = "rbxassetid://10734972463",
			["stopcircle"] = "rbxassetid://10734972621",
			["stretchhorizontal"] = "rbxassetid://10734972862",
			["stretchvertical"] = "rbxassetid://10734973130",
			["strikethrough"] = "rbxassetid://10734973290",
			["subscript"] = "rbxassetid://10734973457",
			["sun"] = "rbxassetid://10734974297",
			["sundim"] = "rbxassetid://10734973645",
			["sunmedium"] = "rbxassetid://10734973778",
			["sunmoon"] = "rbxassetid://10734973999",
			["sunsnow"] = "rbxassetid://10734974130",
			["sunrise"] = "rbxassetid://10734974522",
			["sunset"] = "rbxassetid://10734974689",
			["superscript"] = "rbxassetid://10734974850",
			["swissfranc"] = "rbxassetid://10734975024",
			["switchcamera"] = "rbxassetid://10734975214",
			["sword"] = "rbxassetid://10734975486",
			["swords"] = "rbxassetid://10734975692",
			["syringe"] = "rbxassetid://10734975932",
			["table"] = "rbxassetid://10734976230",
			["table2"] = "rbxassetid://10734976097",
			["tablet"] = "rbxassetid://10734976394",
			["tag"] = "rbxassetid://10734976528",
			["tags"] = "rbxassetid://10734976739",
			["target"] = "rbxassetid://10734977012",
			["tent"] = "rbxassetid://10734981750",
			["terminal"] = "rbxassetid://10734982144",
			["terminalsquare"] = "rbxassetid://10734981995",
			["textcursor"] = "rbxassetid://10734982395",
			["textcursorinput"] = "rbxassetid://10734982297",
			["thermometer"] = "rbxassetid://10734983134",
			["thermometersnowflake"] = "rbxassetid://10734982571",
			["thermometersun"] = "rbxassetid://10734982771",
			["thumbsdown"] = "rbxassetid://10734983359",
			["thumbsup"] = "rbxassetid://10734983629",
			["ticket"] = "rbxassetid://10734983868",
			["timer"] = "rbxassetid://10734984606",
			["timeroff"] = "rbxassetid://10734984138",
			["timerreset"] = "rbxassetid://10734984355",
			["toggleleft"] = "rbxassetid://10734984834",
			["toggleright"] = "rbxassetid://10734985040",
			["tornado"] = "rbxassetid://10734985247",
			["toybrick"] = "rbxassetid://10747361919",
			["train"] = "rbxassetid://10747362105",
			["trash"] = "rbxassetid://10747362393",
			["trash2"] = "rbxassetid://10747362241",
			["treedeciduous"] = "rbxassetid://10747362534",
			["treepine"] = "rbxassetid://10747362748",
			["trees"] = "rbxassetid://10747363016",
			["trendingdown"] = "rbxassetid://10747363205",
			["trendingup"] = "rbxassetid://10747363465",
			["triangle"] = "rbxassetid://10747363621",
			["trophy"] = "rbxassetid://10747363809",
			["truck"] = "rbxassetid://10747364031",
			["tv"] = "rbxassetid://10747364593",
			["tv2"] = "rbxassetid://10747364302",
			["type"] = "rbxassetid://10747364761",
			["umbrella"] = "rbxassetid://10747364971",
			["underline"] = "rbxassetid://10747365191",
			["undo"] = "rbxassetid://10747365484",
			["undo2"] = "rbxassetid://10747365359",
			["unlink"] = "rbxassetid://10747365771",
			["unlink2"] = "rbxassetid://10747397871",
			["unlock"] = "rbxassetid://10747366027",
			["upload"] = "rbxassetid://10747366434",
			["uploadcloud"] = "rbxassetid://10747366266",
			["usb"] = "rbxassetid://10747366606",
			["user"] = "rbxassetid://10747373176",
			["usercheck"] = "rbxassetid://10747371901",
			["usercog"] = "rbxassetid://10747372167",
			["userminus"] = "rbxassetid://10747372346",
			["userplus"] = "rbxassetid://10747372702",
			["userx"] = "rbxassetid://10747372992",
			["users"] = "rbxassetid://10747373426",
			["utensils"] = "rbxassetid://10747373821",
			["utensilscrossed"] = "rbxassetid://10747373629",
			["venetianmask"] = "rbxassetid://10747374003",
			["verified"] = "rbxassetid://10747374131",
			["vibrate"] = "rbxassetid://10747374489",
			["vibrateoff"] = "rbxassetid://10747374269",
			["video"] = "rbxassetid://10747374938",
			["videooff"] = "rbxassetid://10747374721",
			["view"] = "rbxassetid://10747375132",
			["voicemail"] = "rbxassetid://10747375281",
			["volume"] = "rbxassetid://10747376008",
			["volume1"] = "rbxassetid://10747375450",
			["volume2"] = "rbxassetid://10747375679",
			["volumex"] = "rbxassetid://10747375880",
			["wallet"] = "rbxassetid://10747376205",
			["wand"] = "rbxassetid://10747376565",
			["wand2"] = "rbxassetid://10747376349",
			["watch"] = "rbxassetid://10747376722",
			["waves"] = "rbxassetid://10747376931",
			["webcam"] = "rbxassetid://10747381992",
			["wifi"] = "rbxassetid://10747382504",
			["wifioff"] = "rbxassetid://10747382268",
			["wind"] = "rbxassetid://10747382750",
			["wraptext"] = "rbxassetid://10747383065",
			["wrench"] = "rbxassetid://10747383470",
				["x"] = "rbxassetid://10747384394",
			["xcircle"] = "rbxassetid://10747383819",
			["xoctagon"] = "rbxassetid://10747384037",
			["xsquare"] = "rbxassetid://10747384217",
			["zoomin"] = "rbxassetid://10747384552",
			["zoomout"] = "rbxassetid://10747384679"
		}
	end)()
}

-- ////////////////////////////////////////////////////////////////// --
-- Configurações gerais
-- ////////////////////////////////////////////////////////////////// --
local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450
local MainFont = Enum.Font.Creepster -- troque aqui para mudar a fonte de toda a UI (ex: Enum.Font.GothamMedium)
local DefaultBackground = "rbxassetid://80091102303163"

local Settings = redzlib.Settings
local Flags = redzlib.Flags

-- Garante que todo tema tenha todas as chaves
for _, T in pairs(redzlib.Themes) do
	T["Color Section"] = T["Color Section"] or T["Color Dark Text"]
	T["Color SubTitle"] = T["Color SubTitle"] or T["Color Theme"]
end

local function VerifyTheme(Name)
	return type(Name) == "string" and redzlib.Themes[Name] ~= nil
end

local function SaveJson(FileName, save)
	if writefile then
		pcall(function()
			writefile(FileName, HttpService:JSONEncode(save))
		end)
	end
end

-- Carrega configurações salvas (UISize, TabSize, Theme)
do
	local File = "redz library V5.json"
	pcall(function()
		if readfile and isfile and isfile(File) then
			local decode = HttpService:JSONDecode(readfile(File))
			if type(decode) == "table" then
				if type(decode.UISize) == "table" then redzlib.Save.UISize = decode.UISize end
				if type(decode.TabSize) == "number" then redzlib.Save.TabSize = decode.TabSize end
				if VerifyTheme(decode.Theme) then redzlib.Save.Theme = decode.Theme end
			end
		end
	end)
end

-- ////////////////////////////////////////////////////////////////// --
-- Helpers de criação
-- ////////////////////////////////////////////////////////////////// --
local SetProps, SetChildren, InsertTheme, Create do
	InsertTheme = function(Obj, Type)
		table.insert(redzlib.Instances, {
			Instance = Obj,
			Type = Type
		})
		return Obj
	end

	SetChildren = function(Obj, Children)
		if Children then
			for _, Child in pairs(Children) do
				Child.Parent = Obj
			end
		end
		return Obj
	end

	SetProps = function(Obj, Props)
		if Props then
			for prop, value in pairs(Props) do
				Obj[prop] = value
			end
		end
		return Obj
	end

	-- Create("Class", {props}, {children})  ou  Create("Class", Parent, {props}, {children})
	Create = function(...)
		local args = {...}
		local new = Instance.new(args[1])

		if type(args[2]) == "table" then
			SetProps(new, args[2])
			SetChildren(new, args[3])
		elseif typeof(args[2]) == "Instance" then
			new.Parent = args[2]
			SetProps(new, args[3])
			SetChildren(new, args[4])
		end
		return new
	end
end

local Funcs = {} do
	function Funcs:InsertCallback(tab, func)
		if type(func) == "function" then
			table.insert(tab, func)
		end
		return func
	end

	-- Substitui todos os callbacks por um novo
	function Funcs:SetCallback(tab, func)
		if type(func) == "function" then
			table.clear(tab)
			table.insert(tab, func)
		end
	end

	function Funcs:FireCallback(tab, ...)
		for _, v in ipairs(tab) do
			if type(v) == "function" then
				task.spawn(v, ...)
			end
		end
	end

	-- Bool == nil alterna a visibilidade
	function Funcs:ToggleVisible(Obj, Bool)
		if Bool == nil then
			Obj.Visible = not Obj.Visible
		else
			Obj.Visible = Bool
		end
	end

	function Funcs:GetConnectionFunctions(ConnectedFuncs, func)
		local Connected = { Function = func, Connected = true }

		function Connected:Disconnect()
			if self.Connected then
				local index = table.find(ConnectedFuncs, self.Function)
				if index then
					table.remove(ConnectedFuncs, index)
				end
				self.Connected = false
			end
		end

		function Connected:Fire(...)
			if self.Connected then
				task.spawn(self.Function, ...)
			end
		end

		return Connected
	end

	function Funcs:GetCallback(Configs, index)
		local func = Configs[index] or Configs.Callback or function() end

		if type(func) == "table" then
			return {function(Value) func[1][func[2]] = Value end}
		end
		return {func}
	end
end

local Connections, Connection = {}, redzlib.Connection do
	local function NewConnectionList(List)
		for _, CoName in ipairs(List) do
			local ConnectedFuncs, Connect = {}, {}
			Connection[CoName] = Connect
			Connections[CoName] = ConnectedFuncs
			Connect.Name = CoName

			function Connect:Connect(func)
				if type(func) == "function" then
					table.insert(ConnectedFuncs, func)
					return Funcs:GetConnectionFunctions(ConnectedFuncs, func)
				end
			end

			function Connect:Once(func)
				if type(func) == "function" then
					local Connected
					local function _NFunc(...)
						Connected:Disconnect()
						task.spawn(func, ...)
					end

					table.insert(ConnectedFuncs, _NFunc)
					Connected = Funcs:GetConnectionFunctions(ConnectedFuncs, _NFunc)
					return Connected
				end
			end
		end
	end

	function Connection:FireConnection(CoName, ...)
		local List = type(CoName) == "string" and Connections[CoName] or Connections[CoName.Name]
		if not List then return end
		for _, Func in ipairs(table.clone(List)) do
			task.spawn(Func, ...)
		end
	end

	NewConnectionList({"FlagsChanged", "ThemeChanged", "FileSaved", "ThemeChanging", "OptionAdded"})
end

local GetFlag, SetFlag, CheckFlag do
	CheckFlag = function(Name)
		return type(Name) == "string" and Flags[Name] ~= nil
	end

	GetFlag = function(Name)
		return type(Name) == "string" and Flags[Name]
	end

	SetFlag = function(Flag, Value)
		if Flag and (Value ~= Flags[Flag] or type(Value) == "table") then
			Flags[Flag] = Value
			Connection:FireConnection("FlagsChanged", Flag, Value)
		end
	end

	local db
	Connection.FlagsChanged:Connect(function()
		local ScriptFile = Settings.ScriptFile
		if not db and ScriptFile and writefile then
			db = true; task.wait(0.1); db = false

			local Success, Encoded = pcall(function()
				return HttpService:JSONEncode(Flags)
			end)

			if Success then
				local Saved = pcall(writefile, ScriptFile, Encoded)
				if Saved then
					Connection:FireConnection("FileSaved", "Script-Flags", ScriptFile, Encoded)
				end
			end
		end
	end)
end

-- ////////////////////////////////////////////////////////////////// --
-- ScreenGui
-- ////////////////////////////////////////////////////////////////// --
local GuiName = "redz Library V5"
local GuiParent = CoreGui
do
	local ok, res = pcall(function() return gethui and gethui() end)
	if ok and res then GuiParent = res end

	-- remove janela antiga antes de criar a nova
	for _, Parent in ipairs({CoreGui, GuiParent}) do
		pcall(function()
			local Old = Parent:FindFirstChild(GuiName)
			if Old then Old:Destroy() end
		end)
	end
end

local ScreenGui = Create("ScreenGui", GuiParent, {
	Name = GuiName,
	IgnoreGuiInset = true,
	ResetOnSpawn = false
}, {
	Create("UIScale", {
		Scale = UIScale,
		Name = "Scale"
	})
})

-- ////////////////////////////////////////////////////////////////// --
-- Utilidades
-- ////////////////////////////////////////////////////////////////// --
local function GetStr(val)
	if type(val) == "function" then
		return val()
	end
	return val
end

local function IsPointer(Input)
	return Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch
end

-- Retorna (Held, GetPosition) para acompanhar um clique/toque
local function TrackInput(Input)
	local IsTouch = Input.UserInputType == Enum.UserInputType.Touch

	local function Held()
		if IsTouch then
			return Input.UserInputState ~= Enum.UserInputState.End
				and Input.UserInputState ~= Enum.UserInputState.Cancel
		end
		return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	end

	local function GetPosition()
		if IsTouch then
			return Vector2.new(Input.Position.X, Input.Position.Y)
		end
		return UserInputService:GetMouseLocation()
	end

	return Held, GetPosition
end

-- Executa func() quando o clique/toque que começou em Instance for solto
local function ConnectSave(Instance, func)
	Instance.InputBegan:Connect(function(Input)
		if not IsPointer(Input) then return end

		local Held = TrackInput(Input)
		while Held() do task.wait() end
		func()
	end)
end

local function CreateTween(Configs)
	local Obj = Configs[1] or Configs.Instance
	local Prop = Configs[2] or Configs.Prop
	local NewVal = Configs[3] or Configs.NewVal
	local Time = Configs[4] or Configs.Time or 0.5
	local TweenWait = Configs[5] or Configs.wait or false
	local Info = TweenInfo.new(Time, Enum.EasingStyle.Quint)

	local Tween = TweenService:Create(Obj, Info, {[Prop] = NewVal})
	Tween:Play()
	if TweenWait then
		Tween.Completed:Wait()
	end
	return Tween
end

local function MakeDrag(Obj)
	SetProps(Obj, {
		Active = true,
		AutoButtonColor = false
	})

	-- MouseButton1Down só dispara quando o clique é no próprio objeto (não nos filhos)
	local Armed = false
	Obj.MouseButton1Down:Connect(function()
		Armed = true
	end)

	Obj.InputBegan:Connect(function(Input)
		if not IsPointer(Input) then return end

		local Held, GetPosition = TrackInput(Input)
		local DragStart, StartPos = GetPosition(), Obj.Position

		while Held() do
			RunService.Heartbeat:Wait()
			if Armed then
				local delta = GetPosition() - DragStart
				Obj.Position = UDim2.new(
					StartPos.X.Scale, StartPos.X.Offset + delta.X / UIScale,
					StartPos.Y.Scale, StartPos.Y.Offset + delta.Y / UIScale
				)
			end
		end
		Armed = false
	end)
	return Obj
end

local Theme = redzlib.Themes[redzlib.Save.Theme] or redzlib.Themes.Halloween

local function AddEle(Name, Func)
	redzlib.Elements[Name] = Func
end

local function Make(Ele, Obj, props, ...)
	return redzlib.Elements[Ele](Obj, props, ...)
end

AddEle("Corner", function(parent, CornerRadius)
	return Create("UICorner", parent, {
		CornerRadius = CornerRadius or UDim.new(0, 7)
	})
end)

AddEle("Stroke", function(parent, props, ...)
	local args = {...}
	return InsertTheme(SetProps(Create("UIStroke", parent, {
		Color = args[1] or Theme["Color Stroke"],
		Thickness = args[2] or 1,
		ApplyStrokeMode = "Border"
	}), props), "Stroke")
end)

AddEle("Button", function(parent, props, ...)
	local args = {...}
	local New = InsertTheme(SetProps(Create("TextButton", parent, {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme["Color Hub 2"],
		AutoButtonColor = false
	}), props), "Frame")

	New.MouseEnter:Connect(function()
		New.BackgroundTransparency = 0.4
	end)
	New.MouseLeave:Connect(function()
		New.BackgroundTransparency = 0
	end)
	if args[1] then
		New.Activated:Connect(args[1])
	end
	return New
end)

AddEle("Gradient", function(parent, props)
	return InsertTheme(SetProps(Create("UIGradient", parent, {
		Color = Theme["Color Hub 1"]
	}), props), "Gradient")
end)

local function ButtonFrame(Parent, Title, Description, HolderSize)
	local TitleL = InsertTheme(Create("TextLabel", {
		Font = MainFont,
		TextColor3 = Theme["Color Text"],
		Size = UDim2.new(1, -20, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		TextTruncate = "AtEnd",
		TextSize = 14,
		TextXAlignment = "Left",
		Text = "",
		RichText = true
	}), "Text")

	local DescL = InsertTheme(Create("TextLabel", {
		Font = MainFont,
		TextColor3 = Theme["Color Dark Text"],
		Size = UDim2.new(1, -20, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(0, 12, 0, 15),
		BackgroundTransparency = 1,
		TextWrapped = true,
		TextSize = 8,
		TextXAlignment = "Left",
		Text = "",
		RichText = true
	}), "DarkText")

	local Frame = Make("Button", Parent, {
		Size = UDim2.new(1, 0, 0, 25),
		AutomaticSize = "Y",
		Name = "Option"
	})
	Make("Corner", Frame, UDim.new(0, 6))

	local LabelHolder = Create("Frame", Frame, {
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
		Size = HolderSize,
		Position = UDim2.new(0, 10, 0, 0),
		AnchorPoint = Vector2.new(0, 0)
	}, {
		Create("UIListLayout", {
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Center",
			Padding = UDim.new(0, 2)
		}),
		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5)
		}),
		TitleL,
		DescL,
	})

	local Label = {}
	function Label:SetTitle(NewTitle)
		if type(NewTitle) == "string" and NewTitle:gsub(" ", ""):len() > 0 then
			TitleL.Text = NewTitle
		end
	end
	function Label:SetDesc(NewDesc)
		if type(NewDesc) == "string" and NewDesc:gsub(" ", ""):len() > 0 then
			DescL.Visible = true
			DescL.Text = NewDesc
			LabelHolder.Position = UDim2.new(0, 10, 0, 0)
			LabelHolder.AnchorPoint = Vector2.new(0, 0)
		else
			DescL.Visible = false
			DescL.Text = ""
			LabelHolder.Position = UDim2.new(0, 10, 0.5, 0)
			LabelHolder.AnchorPoint = Vector2.new(0, 0.5)
		end
	end

	Label:SetTitle(Title)
	Label:SetDesc(Description)
	return Frame, Label
end

local function GetColor(Obj)
	if Obj:IsA("UIStroke") then
		return "Color"
	elseif Obj:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	elseif Obj:IsA("ImageLabel") or Obj:IsA("ImageButton") then
		return "ImageColor3"
	elseif Obj:IsA("TextLabel") or Obj:IsA("TextButton") or Obj:IsA("TextBox") then
		return "TextColor3"
	end
	return "BackgroundColor3"
end

-- ////////////////////////////////////////////////////////////////// --
-- API pública
-- ////////////////////////////////////////////////////////////////// --
function redzlib:GetIcon(index)
	if type(index) ~= "string" or index:find("rbxassetid://") or #index == 0 then
		return index
	end

	local firstMatch = nil
	index = string.lower(index):gsub("lucide", ""):gsub("-", "")

	for Name, Icon in pairs(self.Icons) do
		Name = Name:gsub("lucide", ""):gsub("-", "")
		if Name == index then
			return Icon
		elseif not firstMatch and Name:find(index, 1, true) then
			firstMatch = Icon
		end
	end

	return firstMatch or index
end

function redzlib:SetTheme(NewTheme)
	if not VerifyTheme(NewTheme) then return end

	redzlib.Save.Theme = NewTheme
	SaveJson("redz library V5.json", redzlib.Save)
	Theme = redzlib.Themes[NewTheme]

	Connection:FireConnection("ThemeChanged", NewTheme)

	for _, Val in ipairs(redzlib.Instances) do
		local Obj, Type = Val.Instance, Val.Type
		if Obj then
			pcall(function()
				if Type == "Gradient" then
					Obj.Color = Theme["Color Hub 1"]
				elseif Type == "Frame" or Type == "Main" then
					Obj.BackgroundColor3 = Theme["Color Hub 2"]
				elseif Type == "Stroke" then
					Obj[GetColor(Obj)] = Theme["Color Stroke"]
				elseif Type == "Theme" then
					Obj[GetColor(Obj)] = Theme["Color Theme"]
				elseif Type == "Text" then
					Obj[GetColor(Obj)] = Theme["Color Text"]
				elseif Type == "DarkText" then
					Obj[GetColor(Obj)] = Theme["Color Dark Text"]
				elseif Type == "Section" then
					Obj[GetColor(Obj)] = Theme["Color Section"]
				elseif Type == "SubTitle" then
					Obj[GetColor(Obj)] = Theme["Color SubTitle"]
				elseif Type == "ScrollBar" then
					Obj.ScrollBarImageColor3 = Theme["Color Theme"]
				end
			end)
		end
	end
end

function redzlib:SetScale(NewScale)
	NewScale = ViewportSize.Y / math.clamp(NewScale, 300, 2000)
	UIScale, ScreenGui.Scale.Scale = NewScale, NewScale
end

function redzlib:MakeWindow(Configs)
	Configs = Configs or {}
	local WTitle = Configs[1] or Configs.Name or Configs.Title or "redz Library V5"
	local WMiniText = Configs[2] or Configs.SubTitle or "by : redz9999"
	local WBackground = Configs.Background
	if WBackground == nil then WBackground = DefaultBackground end

	Settings.ScriptFile = Configs[3] or Configs.SaveFolder or false

	local function LoadFile()
		local File = Settings.ScriptFile
		if type(File) ~= "string" then return end
		if not readfile or not isfile then return end
		local s, r = pcall(isfile, File)

		if s and r then
			local s2, _Flags = pcall(readfile, File)

			if s2 and type(_Flags) == "string" then
				local s3, decoded = pcall(function() return HttpService:JSONDecode(_Flags) end)
				Flags = s3 and type(decoded) == "table" and decoded or {}
				redzlib.Flags = Flags
			end
		end
	end; LoadFile()

	local Minimized, SaveSize, WaitClick
	local UISizeX, UISizeY = unpack(redzlib.Save.UISize)

	local MainFrame = InsertTheme(Create("ImageButton", ScreenGui, {
		Size = UDim2.fromOffset(UISizeX, UISizeY),
		Position = UDim2.new(0.5, -UISizeX / 2, 0.5, -UISizeY / 2),
		BackgroundColor3 = Theme["Color Hub 2"],
		BackgroundTransparency = 0,
		Name = "Hub",
		ClipsDescendants = true
	}), "Main")

	local MainCorner = Make("Corner", MainFrame)

	if WBackground then
		local BgImage = Create("ImageLabel", MainFrame, {
			Name = "AnimatedBackground",
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Image = WBackground,
			ImageTransparency = 0.1,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 0
		})
		Make("Corner", BgImage)
	end

	Make("Gradient", MainFrame, {
		Rotation = 45,
		Transparency = NumberSequence.new(0.8) -- semi-transparente para aparecer o fundo
	})

	local Components = Create("Folder", MainFrame, {
		Name = "Components"
	})

	local DropdownHolder = Create("Folder", ScreenGui, {
		Name = "Dropdown"
	})

	local TopBar = Create("Frame", Components, {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		Name = "Top Bar"
	})

	local TopBarImage = Create("ImageLabel", TopBar, {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, 15, 0, 6),
		BackgroundTransparency = 1,
		Image = "rbxassetid://10734982144",
		Name = "TopBarImage"
	})
	Make("Corner", TopBarImage, UDim.new(0, 5))

	MakeDrag(MainFrame)

	local Title = InsertTheme(Create("TextLabel", TopBar, {
		Position = UDim2.new(0, 45, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = "XY",
		Text = WTitle,
		TextXAlignment = "Left",
		TextSize = 12,
		TextColor3 = Theme["Color Text"],
		BackgroundTransparency = 1,
		Font = MainFont,
		Name = "Title"
	}, {
		InsertTheme(Create("TextLabel", {
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = "X",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(1, 5, 0.9, 0),
			Text = WMiniText,
			TextColor3 = Theme["Color SubTitle"],
			BackgroundTransparency = 1,
			TextXAlignment = "Left",
			TextYAlignment = "Bottom",
			TextSize = 9,
			Font = MainFont,
			Name = "SubTitle"
		}), "SubTitle")
	}), "Text")

	local MainScroll = InsertTheme(Create("ScrollingFrame", Components, {
		Size = UDim2.new(0, redzlib.Save.TabSize, 1, -TopBar.Size.Y.Offset),
		ScrollBarImageColor3 = Theme["Color Theme"],
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		ScrollBarThickness = 1.5,
		BackgroundTransparency = 1,
		ScrollBarImageTransparency = 0.2,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
		BorderSizePixel = 0,
		Name = "Tab Scroll"
	}, {
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}), Create("UIListLayout", {
			Padding = UDim.new(0, 5)
		})
	}), "ScrollBar")

	local Containers = Create("Frame", Components, {
		Size = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Name = "Containers"
	})

	local ControlSize1 = MakeDrag(Create("ImageButton", MainFrame, {
		Size = UDim2.new(0, 35, 0, 35),
		Position = MainFrame.Size,
		Active = true,
		AnchorPoint = Vector2.new(0.8, 0.8),
		BackgroundTransparency = 1,
		Name = "Control Hub Size"
	}))
	local ControlSize2 = MakeDrag(Create("ImageButton", MainFrame, {
		Size = UDim2.new(0, 20, 1, -30),
		Position = UDim2.new(0, MainScroll.Size.X.Offset, 1, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Active = true,
		BackgroundTransparency = 1,
		Name = "Control Tab Size"
	}))

	local function ControlSize()
		local Pos1, Pos2 = ControlSize1.Position, ControlSize2.Position
		ControlSize1.Position = UDim2.fromOffset(math.clamp(Pos1.X.Offset, 430, 1000), math.clamp(Pos1.Y.Offset, 200, 500))
		ControlSize2.Position = UDim2.new(0, math.clamp(Pos2.X.Offset, 135, 250), 1, 0)

		MainScroll.Size = UDim2.new(0, ControlSize2.Position.X.Offset, 1, -TopBar.Size.Y.Offset)
		Containers.Size = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset)
		MainFrame.Size = ControlSize1.Position
	end

	ControlSize1:GetPropertyChangedSignal("Position"):Connect(ControlSize)
	ControlSize2:GetPropertyChangedSignal("Position"):Connect(ControlSize)

	ConnectSave(ControlSize1, function()
		if not Minimized then
			redzlib.Save.UISize = {MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset}
			SaveJson("redz library V5.json", redzlib.Save)
		end
	end)

	ConnectSave(ControlSize2, function()
		redzlib.Save.TabSize = MainScroll.Size.X.Offset
		SaveJson("redz library V5.json", redzlib.Save)
	end)

	local ButtonsFolder = Create("Folder", TopBar, {
		Name = "Buttons"
	})

	local CloseButton = Create("ImageButton", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, -20, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://10747384394",
		AutoButtonColor = false,
		Name = "Close"
	})

	local MinimizeButton = SetProps(CloseButton:Clone(), {
		Position = UDim2.new(1, -45, 0.5, 0),
		Image = "rbxassetid://10734896206",
		Name = "Minimize"
	})

	SetChildren(ButtonsFolder, {
		CloseButton,
		MinimizeButton
	})

	local Window, FirstTab = {}, false

	function Window:CloseBtn()
		Window:Dialog({
			Title = "Fechar",
			Text = ("Deseja realmente fechar o %s?"):format(tostring(WTitle)),
			Options = {
				{"Confirmar", function()
					ScreenGui:Destroy()
					table.clear(redzlib.Instances)
				end},
				{"Cancelar"}
			}
		})
	end

	function Window:MinimizeBtn()
		if WaitClick then return end
		WaitClick = true

		if Minimized then
			MinimizeButton.Image = "rbxassetid://10734896206"
			CreateTween({MainFrame, "Size", SaveSize, 0.25, true})
			ControlSize1.Visible = true
			ControlSize2.Visible = true
			Minimized = false
		else
			MinimizeButton.Image = "rbxassetid://10734924532"
			SaveSize = MainFrame.Size
			ControlSize1.Visible = false
			ControlSize2.Visible = false
			CreateTween({MainFrame, "Size", UDim2.fromOffset(MainFrame.Size.X.Offset, 38), 0.25, true})
			Minimized = true
		end

		WaitClick = false
	end

	function Window:Minimize()
		MainFrame.Visible = not MainFrame.Visible
	end

	function Window:AddMinimizeButton(Configs)
		Configs = Configs or {}

		local Button = MakeDrag(Create("ImageButton", ScreenGui, {
			Size = UDim2.fromOffset(60, 60),
			Position = UDim2.fromScale(0.15, 0.15),
			BackgroundTransparency = 0,
			BackgroundColor3 = Theme["Color Hub 2"],
			Image = "rbxassetid://10734887784",
			AutoButtonColor = false
		}))
		InsertTheme(Button, "Frame")

		local Corner = Make("Corner", Button, UDim.new(0, 12))
		if Configs.Corner then
			SetProps(Corner, Configs.Corner)
		end

		local Stroke = Make("Stroke", Button)
		if Configs.Stroke then
			SetProps(Stroke, Configs.Stroke)
		else
			Stroke.Thickness = 2
			Stroke.Transparency = 0
		end

		SetProps(Button, Configs.Button)

		-- só minimiza se o botão não foi arrastado
		local PressPos
		Button.InputBegan:Connect(function(Input)
			if IsPointer(Input) then PressPos = Button.Position end
		end)
		Button.Activated:Connect(function()
			if PressPos == nil or Button.Position == PressPos then
				Window:Minimize()
			end
		end)

		return {
			Stroke = Stroke,
			Corner = Corner,
			Button = Button
		}
	end

	function Window:Set(Val1, Val2)
		if type(Val1) == "string" and type(Val2) == "string" then
			Title.Text = Val1
			Title.SubTitle.Text = Val2
		elseif type(Val1) == "string" then
			Title.Text = Val1
		end
	end

	function Window:Dialog(Configs)
		if MainFrame:FindFirstChild("Dialog") then return end
		if Minimized then
			Window:MinimizeBtn()
		end

		local DTitle = Configs[1] or Configs.Title or "Dialog"
		local DText = Configs[2] or Configs.Text or "This is a Dialog"
		local DOptions = Configs[3] or Configs.Options or {}

		local Frame = Create("Frame", {
			Active = true,
			Size = UDim2.fromOffset(250 * 1.08, 150 * 1.08),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}, {
			InsertTheme(Create("TextLabel", {
				Font = MainFont,
				Size = UDim2.new(1, 0, 0, 20),
				Text = DTitle,
				TextXAlignment = "Left",
				TextColor3 = Theme["Color Text"],
				TextSize = 15,
				Position = UDim2.fromOffset(15, 5),
				BackgroundTransparency = 1
			}), "Text"),
			InsertTheme(Create("TextLabel", {
				Font = MainFont,
				Size = UDim2.new(1, -25, 0, 0),
				AutomaticSize = "Y",
				Text = DText,
				TextXAlignment = "Left",
				TextColor3 = Theme["Color Dark Text"],
				TextSize = 12,
				Position = UDim2.fromOffset(15, 25),
				BackgroundTransparency = 1,
				TextWrapped = true
			}), "DarkText")
		})
		Make("Gradient", Frame, {Rotation = 270})
		Make("Corner", Frame)

		local ButtonsHolder = Create("Frame", Frame, {
			Size = UDim2.fromScale(1, 0.35),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 10),
				VerticalAlignment = "Center",
				FillDirection = "Horizontal",
				HorizontalAlignment = "Center"
			})
		})

		local Screen = InsertTheme(Create("Frame", MainFrame, {
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Theme["Color Stroke"],
			Name = "Dialog"
		}), "Stroke")

		MainCorner:Clone().Parent = Screen
		Frame.Parent = Screen
		CreateTween({Frame, "Size", UDim2.fromOffset(250, 150), 0.2})
		CreateTween({Frame, "BackgroundTransparency", 0, 0.15})
		CreateTween({Screen, "BackgroundTransparency", 0.3, 0.15})

		local ButtonCount, Dialog = 0, {}

		function Dialog:Button(BConfigs)
			local Name = BConfigs[1] or BConfigs.Name or BConfigs.Title or ""
			local Callback = BConfigs[2] or BConfigs.Callback or function() end

			ButtonCount = ButtonCount + 1
			local Button = Make("Button", ButtonsHolder)
			Make("Corner", Button)
			SetProps(Button, {
				Text = Name,
				Font = MainFont,
				TextColor3 = Theme["Color Text"],
				TextSize = 12
			})

			for _, B in pairs(ButtonsHolder:GetChildren()) do
				if B:IsA("TextButton") then
					B.Size = UDim2.new(1 / ButtonCount, -(((ButtonCount - 1) * 20) / ButtonCount), 0, 32) -- Fluent Library :)
				end
			end
			Button.Activated:Connect(function() Dialog:Close() end)
			Button.Activated:Connect(Callback)
		end

		function Dialog:Close()
			CreateTween({Frame, "Size", UDim2.fromOffset(250 * 1.08, 150 * 1.08), 0.2})
			CreateTween({Screen, "BackgroundTransparency", 1, 0.15})
			CreateTween({Frame, "BackgroundTransparency", 1, 0.15, true})
			Screen:Destroy()
		end

		for _, Button in ipairs(DOptions) do
			Dialog:Button(Button)
		end
		return Dialog
	end

	function Window:SelectTab(TabSelect)
		if type(TabSelect) == "number" then
			local Found = redzlib.Tabs[TabSelect]
			if Found then Found.func:Enable() end
		elseif type(TabSelect) == "table" then
			for _, Tab in pairs(redzlib.Tabs) do
				if Tab.Cont == TabSelect.Cont then
					Tab.func:Enable()
				end
			end
		end
	end

	local ContainerList = {}
	function Window:MakeTab(paste, Configs)
		if type(paste) == "table" then Configs = paste end
		local TName = Configs[1] or Configs.Title or "Tab!"
		local TIcon = Configs[2] or Configs.Icon or ""

		TIcon = redzlib:GetIcon(TIcon)
		if type(TIcon) ~= "string" or not TIcon:find("rbxassetid://") or TIcon:gsub("rbxassetid://", ""):len() < 6 then
			TIcon = false
		end

		local TabSelect = Make("Button", MainScroll, {
			Size = UDim2.new(1, 0, 0, 24)
		})
		Make("Corner", TabSelect)

		local LabelTitle = InsertTheme(Create("TextLabel", TabSelect, {
			Size = UDim2.new(1, TIcon and -25 or -15, 1, 0),
			Position = UDim2.fromOffset(TIcon and 25 or 15, 0),
			BackgroundTransparency = 1,
			Font = MainFont,
			Text = TName,
			TextColor3 = Theme["Color Text"],
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTransparency = (FirstTab and 0.3) or 0,
			TextTruncate = "AtEnd"
		}), "Text")

		local LabelIcon = InsertTheme(Create("ImageLabel", TabSelect, {
			Position = UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.new(0, 13, 0, 13),
			AnchorPoint = Vector2.new(0, 0.5),
			Image = TIcon or "",
			BackgroundTransparency = 1,
			ImageTransparency = (FirstTab and 0.3) or 0
		}), "Text")

		local Selected = InsertTheme(Create("Frame", TabSelect, {
			Size = FirstTab and UDim2.new(0, 4, 0, 4) or UDim2.new(0, 4, 0, 13),
			Position = UDim2.new(0, 1, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Theme["Color Theme"],
			BackgroundTransparency = FirstTab and 1 or 0
		}), "Theme")
		Make("Corner", Selected, UDim.new(0.5, 0))

		local Container = InsertTheme(Create("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			ScrollBarThickness = 1.5,
			BackgroundTransparency = 1,
			ScrollBarImageTransparency = 0.2,
			ScrollBarImageColor3 = Theme["Color Theme"],
			AutomaticCanvasSize = "Y",
			ScrollingDirection = "Y",
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			Name = ("Container %i [ %s ]"):format(#ContainerList + 1, TName)
		}, {
			Create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			}), Create("UIListLayout", {
				Padding = UDim.new(0, 5)
			})
		}), "ScrollBar")

		table.insert(ContainerList, Container)

		if not FirstTab then Container.Parent = Containers end

		local function Tabs()
			if Container.Parent then return end
			for _, Frame in pairs(ContainerList) do
				if Frame ~= Container then
					Frame.Parent = nil
				end
			end
			Container.Parent = Containers
			Container.Size = UDim2.new(1, 0, 1, 150)
			for _, Tab in pairs(redzlib.Tabs) do
				if Tab.Cont ~= Container then
					Tab.func:Disable()
				end
			end
			CreateTween({Container, "Size", UDim2.new(1, 0, 1, 0), 0.3})
			CreateTween({LabelTitle, "TextTransparency", 0, 0.35})
			CreateTween({LabelIcon, "ImageTransparency", 0, 0.35})
			CreateTween({Selected, "Size", UDim2.new(0, 4, 0, 13), 0.35})
			CreateTween({Selected, "BackgroundTransparency", 0, 0.35})
		end
		TabSelect.Activated:Connect(Tabs)

		FirstTab = true
		local Tab = {}
		table.insert(redzlib.Tabs, {TabInfo = {Name = TName, Icon = TIcon}, func = Tab, Cont = Container})
		Tab.Cont = Container

		function Tab:Disable()
			Container.Parent = nil
			CreateTween({LabelTitle, "TextTransparency", 0.3, 0.35})
			CreateTween({LabelIcon, "ImageTransparency", 0.3, 0.35})
			CreateTween({Selected, "Size", UDim2.new(0, 4, 0, 4), 0.35})
			CreateTween({Selected, "BackgroundTransparency", 1, 0.35})
		end
		function Tab:Enable()
			Tabs()
		end
		function Tab:Visible(Bool)
			Funcs:ToggleVisible(TabSelect, Bool)
			Container.Visible = TabSelect.Visible
		end
		function Tab:Destroy()
			local index = table.find(ContainerList, Container)
			if index then table.remove(ContainerList, index) end
			TabSelect:Destroy()
			Container:Destroy()
		end

		function Tab:AddSection(SConfigs)
			local SectionName = type(SConfigs) == "string" and SConfigs or SConfigs[1] or SConfigs.Name or SConfigs.Title or SConfigs.Section

			local SectionFrame = Create("Frame", Container, {
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Name = "Option"
			})

			local SectionLabel = InsertTheme(Create("TextLabel", SectionFrame, {
				Font = MainFont,
				Text = SectionName,
				TextColor3 = Theme["Color Section"],
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 30, 0, 0),
				BackgroundTransparency = 1,
				TextTruncate = "AtEnd",
				TextSize = 14,
				TextXAlignment = "Left"
			}), "Section")

			local Section = {}
			table.insert(redzlib.Options, {type = "Section", Name = SectionName, func = Section})
			function Section:Visible(Bool)
				Funcs:ToggleVisible(SectionFrame, Bool)
			end
			function Section:Destroy()
				SectionFrame:Destroy()
			end
			function Section:Set(New)
				if New then
					SectionLabel.Text = GetStr(New)
				end
			end
			return Section
		end

		function Tab:AddParagraph(PConfigs)
			local PName = PConfigs[1] or PConfigs.Title or "Paragraph"
			local PDesc = PConfigs[2] or PConfigs.Text or ""

			local Frame, LabelFunc = ButtonFrame(Container, PName, PDesc, UDim2.new(1, -20, 0, 0))

			local Paragraph = {}
			function Paragraph:Visible(...) Funcs:ToggleVisible(Frame, ...) end
			function Paragraph:Destroy() Frame:Destroy() end
			function Paragraph:SetTitle(Val)
				LabelFunc:SetTitle(GetStr(Val))
			end
			function Paragraph:SetDesc(Val)
				LabelFunc:SetDesc(GetStr(Val))
			end
			function Paragraph:Set(Val1, Val2)
				if Val1 and Val2 then
					LabelFunc:SetTitle(GetStr(Val1))
					LabelFunc:SetDesc(GetStr(Val2))
				elseif Val1 then
					LabelFunc:SetDesc(GetStr(Val1))
				end
			end
			return Paragraph
		end

		function Tab:AddButton(BConfigs)
			local BName = BConfigs[1] or BConfigs.Name or BConfigs.Title or "Button!"
			local BDescription = BConfigs.Desc or BConfigs.Description or ""
			local Callback = Funcs:GetCallback(BConfigs, 2)

			local FButton, LabelFunc = ButtonFrame(Container, BName, BDescription, UDim2.new(1, -20, 0, 0))

			Create("ImageLabel", FButton, {
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new(1, -10, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://10709791437"
			})

			FButton.Activated:Connect(function()
				Funcs:FireCallback(Callback)
			end)

			local Button = {}
			function Button:Visible(...) Funcs:ToggleVisible(FButton, ...) end
			function Button:Destroy() FButton:Destroy() end
			function Button:Callback(...) Funcs:InsertCallback(Callback, ...) end
			function Button:Set(Val1, Val2)
				if type(Val1) == "string" and type(Val2) == "string" then
					LabelFunc:SetTitle(Val1)
					LabelFunc:SetDesc(Val2)
				elseif type(Val1) == "string" then
					LabelFunc:SetTitle(Val1)
				elseif type(Val1) == "function" then
					Funcs:SetCallback(Callback, Val1)
				end
			end
			return Button
		end

		function Tab:AddToggle(TConfigs)
			local TName = TConfigs[1] or TConfigs.Name or TConfigs.Title or "Toggle"
			local TDesc = TConfigs.Desc or TConfigs.Description or ""
			local Callback = Funcs:GetCallback(TConfigs, 3)
			local Flag = TConfigs[4] or TConfigs.Flag or false
			local Default = TConfigs[2] or TConfigs.Default or false
			if CheckFlag(Flag) then Default = GetFlag(Flag) end

			local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -38, 0, 0))

			local ToggleHolder = InsertTheme(Create("Frame", Button, {
				Size = UDim2.new(0, 35, 0, 18),
				Position = UDim2.new(1, -10, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme["Color Stroke"]
			}), "Stroke")
			Make("Corner", ToggleHolder, UDim.new(0.5, 0))

			local Slider = Create("Frame", ToggleHolder, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0.8, 0, 0.8, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})

			local Knob = InsertTheme(Create("Frame", Slider, {
				Size = UDim2.new(0, 12, 0, 12),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Theme["Color Theme"]
			}), "Theme")
			Make("Corner", Knob, UDim.new(0.5, 0))

			local function SetToggle(Val)
				Default = Val and true or false
				SetFlag(Flag, Default)
				Funcs:FireCallback(Callback, Default)
				if Default then
					CreateTween({Knob, "Position", UDim2.new(1, 0, 0.5, 0), 0.25})
					CreateTween({Knob, "BackgroundTransparency", 0, 0.25})
					CreateTween({Knob, "AnchorPoint", Vector2.new(1, 0.5), 0.25})
				else
					CreateTween({Knob, "Position", UDim2.new(0, 0, 0.5, 0), 0.25})
					CreateTween({Knob, "BackgroundTransparency", 0.8, 0.25})
					CreateTween({Knob, "AnchorPoint", Vector2.new(0, 0.5), 0.25})
				end
			end
			task.spawn(SetToggle, Default)

			Button.Activated:Connect(function()
				SetToggle(not Default)
			end)

			local Toggle = {}
			function Toggle:Visible(...) Funcs:ToggleVisible(Button, ...) end
			function Toggle:Destroy() Button:Destroy() end
			function Toggle:Callback(func)
				if Funcs:InsertCallback(Callback, func) then
					task.spawn(func, Default)
				end
			end
			function Toggle:Set(Val1, Val2)
				if type(Val1) == "string" and type(Val2) == "string" then
					LabelFunc:SetTitle(Val1)
					LabelFunc:SetDesc(Val2)
				elseif type(Val1) == "string" then
					LabelFunc:SetTitle(Val1)
				elseif type(Val1) == "boolean" then
					task.spawn(SetToggle, Val1)
				elseif type(Val1) == "function" then
					Funcs:SetCallback(Callback, Val1)
				end
			end
			return Toggle
		end

		function Tab:AddDropdown(DConfigs)
			local DName = DConfigs[1] or DConfigs.Name or DConfigs.Title or "Dropdown"
			local DDesc = DConfigs.Desc or DConfigs.Description or ""
			local DOptions = DConfigs[2] or DConfigs.Options or {}
			local OpDefault = DConfigs[3] or DConfigs.Default or {}
			local Flag = DConfigs[5] or DConfigs.Flag or false
			local MultiSelect = DConfigs.MultiSelect or false
			local Callback = Funcs:GetCallback(DConfigs, 4)
			local DropWidth = 152

			local Button = ButtonFrame(Container, DName, DDesc, UDim2.new(1, -180, 0, 0))

			local SelectedFrame = InsertTheme(Create("Frame", Button, {
				Size = UDim2.new(0, 150, 0, 18),
				Position = UDim2.new(1, -10, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme["Color Stroke"]
			}), "Stroke")
			Make("Corner", SelectedFrame, UDim.new(0, 4))

			local ActiveLabel = InsertTheme(Create("TextLabel", SelectedFrame, {
				Size = UDim2.new(0.85, 0, 0.85, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				Font = MainFont,
				TextScaled = true,
				TextColor3 = Theme["Color Text"],
				Text = "..."
			}), "Text")

			local Arrow = Create("ImageLabel", SelectedFrame, {
				Size = UDim2.new(0, 15, 0, 15),
				Position = UDim2.new(0, -5, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://10709791523",
				BackgroundTransparency = 1
			})

			local NoClickFrame = Create("TextButton", DropdownHolder, {
				Name = "AntiClick",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Visible = false,
				Text = ""
			})

			-- base branca + gradiente do tema = cor exata do gradiente (painel opaco)
			local DropFrame = Create("Frame", NoClickFrame, {
				Size = UDim2.fromOffset(DropWidth, 0),
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AnchorPoint = Vector2.new(0, 1),
				Name = "DropdownFrame",
				ClipsDescendants = true,
				Active = true
			})
			Make("Corner", DropFrame)
			Make("Stroke", DropFrame)
			Make("Gradient", DropFrame, {Rotation = 60})

			local ScrollFrame = InsertTheme(Create("ScrollingFrame", DropFrame, {
				ScrollBarImageColor3 = Theme["Color Theme"],
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarThickness = 1.5,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(),
				ScrollingDirection = "Y",
				AutomaticCanvasSize = "Y",
				Active = true
			}, {
				Create("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}), Create("UIListLayout", {
					Padding = UDim.new(0, 4)
				})
			}), "ScrollBar")

			local ScrollSize, WaitDrop = 5, false

			local function Disable()
				WaitDrop = true
				CreateTween({Arrow, "Rotation", 0, 0.2})
				CreateTween({DropFrame, "Size", UDim2.fromOffset(DropWidth, 0), 0.2, true})
				CreateTween({Arrow, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
				Arrow.Image = "rbxassetid://10709791523"
				NoClickFrame.Visible = false
				WaitDrop = false
			end

			local function GetFrameSize()
				return UDim2.fromOffset(DropWidth, ScrollSize)
			end

			local function CalculateSize()
				local Count = 0
				for _, Frame in pairs(ScrollFrame:GetChildren()) do
					if Frame.Name == "Option" then
						Count = Count + 1
					end
				end
				ScrollSize = (math.clamp(Count, 0, 10) * 25) + 10
				if NoClickFrame.Visible then
					CreateTween({DropFrame, "Size", GetFrameSize(), 0.2, true})
				end
			end

			local function Minimize()
				if WaitDrop then return end
				WaitDrop = true
				if NoClickFrame.Visible then
					Arrow.Image = "rbxassetid://10709791523"
					CreateTween({Arrow, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
					CreateTween({DropFrame, "Size", UDim2.fromOffset(DropWidth, 0), 0.2, true})
					NoClickFrame.Visible = false
				else
					NoClickFrame.Visible = true
					Arrow.Image = "rbxassetid://10709790948"
					CreateTween({Arrow, "ImageColor3", Theme["Color Theme"], 0.2})
					CreateTween({DropFrame, "Size", GetFrameSize(), 0.2, true})
				end
				WaitDrop = false
			end

			local function CalculatePos()
				local FramePos = SelectedFrame.AbsolutePosition
				local ScreenSize = ScreenGui.AbsoluteSize
				local ClampX = math.clamp(FramePos.X / UIScale, 0, ScreenSize.X / UIScale - DropWidth)
				local ClampY = math.clamp(FramePos.Y / UIScale, 0, ScreenSize.Y / UIScale)

				local NewPos = UDim2.fromOffset(ClampX, ClampY)
				local AnchorY = FramePos.Y > ScreenSize.Y / 1.4 and 1 or ScrollSize > 80 and 0.5 or 0
				DropFrame.AnchorPoint = Vector2.new(0, AnchorY)
				CreateTween({DropFrame, "Position", NewPos, 0.1})
			end

			-- ===== Opções =====
			local Options = {}
			local DefaultList = type(OpDefault) ~= "table" and {OpDefault} or OpDefault
			local Selected

			if MultiSelect then
				Selected = {}
				local Init = CheckFlag(Flag) and GetFlag(Flag) or DefaultList
				for index, Value in pairs(Init) do
					if type(index) == "string" then
						Selected[index] = Value and true or false
					elseif type(Value) == "string" then
						Selected[Value] = true
					end
				end
			else
				Selected = CheckFlag(Flag) and GetFlag(Flag) or DefaultList[1]
			end

			local function CallbackSelected()
				SetFlag(Flag, Selected)
				Funcs:FireCallback(Callback, Selected)
			end

			local function UpdateLabel()
				if MultiSelect then
					local list = {}
					for index, Value in pairs(Selected) do
						if Value then
							table.insert(list, index)
						end
					end
					table.sort(list)
					ActiveLabel.Text = #list > 0 and table.concat(list, ", ") or "..."
				else
					ActiveLabel.Text = tostring(Selected or "...")
				end
			end

			local function UpdateSelected()
				for _, v in pairs(Options) do
					local nodes = v.nodes
					local Active
					if MultiSelect then
						Active = v.Stats
					else
						Active = v.Value == Selected
					end
					CreateTween({nodes[2], "BackgroundTransparency", Active and 0 or (MultiSelect and 0.8 or 1), 0.35})
					CreateTween({nodes[2], "Size", Active and UDim2.fromOffset(4, MultiSelect and 12 or 14) or UDim2.fromOffset(4, 4), 0.35})
					CreateTween({nodes[3], "TextTransparency", Active and 0 or 0.4, 0.35})
				end
				UpdateLabel()
			end

			local function Select(Option)
				if MultiSelect then
					Option.Stats = not Option.Stats
					Selected[Option.Name] = Option.Stats
				else
					Selected = Option.Value
				end
				Option.LastCB = tick()
				CallbackSelected()
				UpdateSelected()
			end

			local function AddOption(index, Value)
				if Value == nil then Value = index end
				local Name = tostring(type(index) == "string" and index or Value)

				if Options[Name] then return end
				local Option = {
					index = index,
					Value = Value,
					Name = Name,
					Stats = false,
					LastCB = 0
				}
				Options[Name] = Option

				if MultiSelect then
					Option.Stats = Selected[Name] or false
					Selected[Name] = Option.Stats
				end

				local OptButton = Make("Button", ScrollFrame, {
					Name = "Option",
					Size = UDim2.new(1, 0, 0, 21),
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5)
				})
				Make("Corner", OptButton, UDim.new(0, 4))

				local IsSelected = InsertTheme(Create("Frame", OptButton, {
					Position = UDim2.new(0, 1, 0.5, 0),
					Size = UDim2.new(0, 4, 0, 4),
					BackgroundColor3 = Theme["Color Theme"],
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5)
				}), "Theme")
				Make("Corner", IsSelected, UDim.new(0.5, 0))

				local OptionName = InsertTheme(Create("TextLabel", OptButton, {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					Text = Name,
					TextColor3 = Theme["Color Text"],
					Font = MainFont,
					TextXAlignment = "Left",
					BackgroundTransparency = 1,
					TextTransparency = 0.4
				}), "Text")

				OptButton.Activated:Connect(function()
					Select(Option)
				end)

				Option.nodes = {OptButton, IsSelected, OptionName}
			end

			local function RemoveOption(index, Value)
				if Value == nil then Value = index end
				local Name = tostring(type(index) == "string" and index or Value)
				local Option = Options[Name]
				if Option then
					if MultiSelect then
						Selected[Name] = nil
					elseif Selected == Option.Value then
						Selected = nil
					end
					Option.nodes[1]:Destroy()
					Options[Name] = nil
				end
			end

			local function AddNewOptions(List, Clear)
				if Clear then
					for _, Option in pairs(table.clone(Options)) do
						RemoveOption(Option.index, Option.Value)
					end
				end
				for index, Value in pairs(List) do
					AddOption(index, Value)
				end
				CallbackSelected()
				UpdateSelected()
			end

			for index, Value in pairs(DOptions) do
				AddOption(index, Value)
			end
			if MultiSelect then
				-- descarta padrões que não existem nas opções
				for Name in pairs(Selected) do
					if not Options[Name] then Selected[Name] = nil end
				end
			end
			CallbackSelected()
			UpdateSelected()

			Button.Activated:Connect(Minimize)
			NoClickFrame.MouseButton1Down:Connect(Disable)
			NoClickFrame.MouseButton1Click:Connect(Disable)
			MainFrame:GetPropertyChangedSignal("Visible"):Connect(Disable)
			SelectedFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(CalculatePos)

			Button.Activated:Connect(CalculateSize)
			ScrollFrame.ChildAdded:Connect(CalculateSize)
			ScrollFrame.ChildRemoved:Connect(CalculateSize)
			CalculatePos()
			CalculateSize()

			local Dropdown = {}
			function Dropdown:Visible(...) Funcs:ToggleVisible(Button, ...) end
			function Dropdown:Destroy() Button:Destroy() NoClickFrame:Destroy() end
			function Dropdown:Callback(func)
				if Funcs:InsertCallback(Callback, func) then
					task.spawn(func, Selected)
				end
			end
			function Dropdown:Add(...)
				local NewOptions = {...}
				if type(NewOptions[1]) == "table" then
					NewOptions = NewOptions[1]
				end
				for _, Name in pairs(NewOptions) do
					AddOption(Name)
				end
			end
			function Dropdown:Remove(Option)
				for _, Value in pairs(table.clone(Options)) do
					if Value.Name == tostring(Option) or Value.index == Option then
						RemoveOption(Value.index, Value.Value)
					end
				end
			end
			function Dropdown:Select(Option)
				for _, Val in pairs(Options) do
					if Val.Name == tostring(Option) or Val.index == Option then
						-- no modo múltiplo, só marca se ainda não estiver marcado
						if not (MultiSelect and Val.Stats) then
							Select(Val)
						end
						return
					end
				end
			end
			-- Set(lista) substitui as opções; Set(lista, true) apenas adiciona
			function Dropdown:Set(Val1, Append)
				if type(Val1) == "table" then
					AddNewOptions(Val1, not Append)
				elseif type(Val1) == "function" then
					Funcs:SetCallback(Callback, Val1)
				end
			end
			return Dropdown
		end

		function Tab:AddSlider(SConfigs)
			local SName = SConfigs[1] or SConfigs.Name or SConfigs.Title or "Slider!"
			local SDesc = SConfigs.Desc or SConfigs.Description or ""
			local Min = SConfigs[2] or SConfigs.MinValue or SConfigs.Min or 10
			local Max = SConfigs[3] or SConfigs.MaxValue or SConfigs.Max or 100
			local Increase = SConfigs[4] or SConfigs.Increase or 1
			local Callback = Funcs:GetCallback(SConfigs, 6)
			local Flag = SConfigs[7] or SConfigs.Flag or false
			local Default = SConfigs[5] or SConfigs.Default or 25
			if CheckFlag(Flag) then Default = GetFlag(Flag) end

			local RealMin, RealMax = Min, Max
			Min, Max = Min / Increase, Max / Increase

			local Button, LabelFunc = ButtonFrame(Container, SName, SDesc, UDim2.new(1, -180, 0, 0))

			local SliderHolder = Create("TextButton", Button, {
				Size = UDim2.new(0.45, 0, 1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				AutoButtonColor = false,
				Text = "",
				BackgroundTransparency = 1
			})

			local SliderBar = InsertTheme(Create("Frame", SliderHolder, {
				BackgroundColor3 = Theme["Color Stroke"],
				Size = UDim2.new(1, -20, 0, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}), "Stroke")
			Make("Corner", SliderBar)

			local Indicator = InsertTheme(Create("Frame", SliderBar, {
				BackgroundColor3 = Theme["Color Theme"],
				Size = UDim2.fromScale(0.3, 1),
				BorderSizePixel = 0
			}), "Theme")
			Make("Corner", Indicator)

			local SliderIcon = Create("Frame", SliderBar, {
				Size = UDim2.new(0, 6, 0, 12),
				BackgroundColor3 = Color3.fromRGB(220, 220, 220),
				Position = UDim2.fromScale(0.3, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 0.2
			})
			Make("Corner", SliderIcon)

			local LabelVal = InsertTheme(Create("TextLabel", SliderHolder, {
				Size = UDim2.new(0, 14, 0, 14),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				BackgroundTransparency = 1,
				TextColor3 = Theme["Color Text"],
				Font = MainFont,
				TextSize = 12
			}), "Text")

			local LabelScale = Create("UIScale", LabelVal)
			local Current

			local function UpdateLabel(NewValue)
				local Number = math.floor(tonumber(NewValue * Increase) * 100 + 0.5) / 100
				if Number == Current then return end

				Current, Default, LabelVal.Text = Number, Number, tostring(Number)
				Funcs:FireCallback(Callback, Number)
			end

			local function UpdateValues()
				Indicator.Size = UDim2.new(SliderIcon.Position.X.Scale, 0, 1, 0)
				local SliderPos = SliderIcon.Position.X.Scale
				UpdateLabel(math.floor(SliderPos * (Max - Min) + Min + 0.5))
			end

			SliderHolder.InputBegan:Connect(function(Input)
				if not IsPointer(Input) then return end

				local Held, GetPosition = TrackInput(Input)
				CreateTween({SliderIcon, "BackgroundTransparency", 0, 0.3})
				Container.ScrollingEnabled = false

				while Held() do
					local APos = GetPosition().X - SliderBar.AbsolutePosition.X
					SliderIcon.Position = UDim2.new(math.clamp(APos / SliderBar.AbsoluteSize.X, 0, 1), 0, 0.5, 0)
					task.wait()
				end

				CreateTween({SliderIcon, "BackgroundTransparency", 0.2, 0.3})
				Container.ScrollingEnabled = true
				SetFlag(Flag, Default)
			end)

			LabelVal:GetPropertyChangedSignal("Text"):Connect(function()
				LabelScale.Scale = 0.3
				CreateTween({LabelScale, "Scale", 1.2, 0.1})
				CreateTween({LabelVal, "Rotation", math.random(-1, 1) * 5, 0.15})
				task.delay(0.15, function()
					CreateTween({LabelScale, "Scale", 1, 0.2})
					CreateTween({LabelVal, "Rotation", 0, 0.1})
				end)
			end)

			local function SetSlider(NewValue)
				if type(NewValue) ~= "number" then return end

				local SliderPos = (NewValue - RealMin) / (RealMax - RealMin)
				SetFlag(Flag, NewValue)
				SliderIcon.Position = UDim2.fromScale(math.clamp(SliderPos, 0, 1), 0.5)
			end

			SetSlider(Default)
			SliderIcon:GetPropertyChangedSignal("Position"):Connect(UpdateValues)
			UpdateValues()

			local Slider = {}
			function Slider:Set(NewVal1, NewVal2)
				if NewVal1 and NewVal2 then
					LabelFunc:SetTitle(NewVal1)
					LabelFunc:SetDesc(NewVal2)
				elseif type(NewVal1) == "string" then
					LabelFunc:SetTitle(NewVal1)
				elseif type(NewVal1) == "function" then
					Funcs:SetCallback(Callback, NewVal1)
				elseif type(NewVal1) == "number" then
					SetSlider(NewVal1)
				end
			end
			function Slider:Callback(func)
				if Funcs:InsertCallback(Callback, func) then
					task.spawn(func, tonumber(Default))
				end
			end
			function Slider:Visible(...) Funcs:ToggleVisible(Button, ...) end
			function Slider:Destroy() Button:Destroy() end
			return Slider
		end

		function Tab:AddTextBox(TConfigs)
			local TName = TConfigs[1] or TConfigs.Name or TConfigs.Title or "Text Box"
			local TDesc = TConfigs.Desc or TConfigs.Description or ""
			local TDefault = TConfigs[2] or TConfigs.Default or ""
			local TPlaceholderText = TConfigs[5] or TConfigs.PlaceholderText or "Input"
			local TClearText = TConfigs[3] or TConfigs.ClearText or false
			local Callback = Funcs:GetCallback(TConfigs, 4)

			if type(TDefault) ~= "string" or TDefault:gsub(" ", ""):len() < 1 then
				TDefault = ""
			end

			local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -38, 0, 0))

			local SelectedFrame = InsertTheme(Create("Frame", Button, {
				Size = UDim2.new(0, 150, 0, 18),
				Position = UDim2.new(1, -10, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme["Color Stroke"]
			}), "Stroke")
			Make("Corner", SelectedFrame, UDim.new(0, 4))

			local TextBoxInput = InsertTheme(Create("TextBox", SelectedFrame, {
				Size = UDim2.new(0.85, 0, 0.85, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				Font = MainFont,
				TextScaled = true,
				TextColor3 = Theme["Color Text"],
				ClearTextOnFocus = TClearText,
				PlaceholderText = TPlaceholderText,
				Text = TDefault
			}), "Text")

			local Pencil = Create("ImageLabel", SelectedFrame, {
				Size = UDim2.new(0, 12, 0, 12),
				Position = UDim2.new(0, -5, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Image = "rbxassetid://15637081879",
				BackgroundTransparency = 1
			})

			local TextBox = {}
			local function Input()
				local Text = TextBoxInput.Text
				if Text:gsub(" ", ""):len() > 0 then
					if TextBox.OnChanging then Text = TextBox.OnChanging(Text) or Text end
					Funcs:FireCallback(Callback, Text)
					TextBoxInput.Text = Text
				end
			end

			TextBoxInput.FocusLost:Connect(Input)
			Input()

			TextBoxInput.FocusLost:Connect(function()
				CreateTween({Pencil, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
			end)
			TextBoxInput.Focused:Connect(function()
				CreateTween({Pencil, "ImageColor3", Theme["Color Theme"], 0.2})
			end)

			TextBox.OnChanging = false
			function TextBox:Visible(...) Funcs:ToggleVisible(Button, ...) end
			function TextBox:Destroy() Button:Destroy() end
			function TextBox:Set(Val1, Val2)
				if type(Val1) == "string" and type(Val2) == "string" then
					LabelFunc:SetTitle(Val1)
					LabelFunc:SetDesc(Val2)
				elseif type(Val1) == "string" then
					TextBoxInput.Text = Val1
					Input()
				elseif type(Val1) == "function" then
					Funcs:SetCallback(Callback, Val1)
				end
			end
			return TextBox
		end

		function Tab:AddDiscordInvite(DConfigs)
			local DTitle = DConfigs[1] or DConfigs.Name or DConfigs.Title or "Discord"
			local Desc = DConfigs.Desc or DConfigs.Description or ""
			local Logo = DConfigs[2] or DConfigs.Logo or ""
			local Invite = DConfigs[3] or DConfigs.Invite or ""

			local InviteHolder = Create("Frame", Container, {
				Size = UDim2.new(1, 0, 0, 80),
				Name = "Option",
				BackgroundTransparency = 1
			})

			Create("TextLabel", InviteHolder, {
				Size = UDim2.new(1, 0, 0, 15),
				Position = UDim2.new(0, 5, 0, 0),
				TextColor3 = Color3.fromRGB(40, 150, 255),
				Font = MainFont,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				TextSize = 10,
				Text = Invite
			})

			local FrameHolder = InsertTheme(Create("Frame", InviteHolder, {
				Size = UDim2.new(1, 0, 0, 65),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = Theme["Color Hub 2"]
			}), "Frame")
			Make("Corner", FrameHolder)

			local ImageLabel = Create("ImageLabel", FrameHolder, {
				Size = UDim2.new(0, 30, 0, 30),
				Position = UDim2.new(0, 7, 0, 7),
				Image = Logo,
				BackgroundTransparency = 1
			})
			Make("Corner", ImageLabel, UDim.new(0, 4))
			Make("Stroke", ImageLabel)

			InsertTheme(Create("TextLabel", FrameHolder, {
				Size = UDim2.new(1, -52, 0, 15),
				Position = UDim2.new(0, 44, 0, 7),
				Font = MainFont,
				TextColor3 = Theme["Color Text"],
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				TextSize = 10,
				Text = DTitle
			}), "Text")

			InsertTheme(Create("TextLabel", FrameHolder, {
				Size = UDim2.new(1, -52, 0, 0),
				Position = UDim2.new(0, 44, 0, 22),
				TextWrapped = true,
				AutomaticSize = "Y",
				Font = Enum.Font.Gotham,
				TextColor3 = Theme["Color Dark Text"],
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				TextSize = 8,
				Text = Desc
			}), "DarkText")

			local JoinButton = Create("TextButton", FrameHolder, {
				Size = UDim2.new(1, -14, 0, 16),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -7),
				Text = "Join",
				Font = MainFont,
				TextSize = 12,
				TextColor3 = Color3.fromRGB(220, 220, 220),
				BackgroundColor3 = Color3.fromRGB(50, 150, 50)
			})
			Make("Corner", JoinButton, UDim.new(0, 5))

			local ClickDelay
			JoinButton.Activated:Connect(function()
				if ClickDelay then return end
				ClickDelay = true

				local Copied = setclipboard and pcall(setclipboard, Invite)
				SetProps(JoinButton, {
					Text = Copied and "Copied to Clipboard" or "Clipboard indisponível",
					BackgroundColor3 = Color3.fromRGB(100, 100, 100),
					TextColor3 = Color3.fromRGB(150, 150, 150)
				})
				task.wait(5)
				SetProps(JoinButton, {
					Text = "Join",
					BackgroundColor3 = Color3.fromRGB(50, 150, 50),
					TextColor3 = Color3.fromRGB(220, 220, 220)
				})
				ClickDelay = false
			end)

			local DiscordInvite = {}
			function DiscordInvite:Destroy() InviteHolder:Destroy() end
			function DiscordInvite:Visible(...) Funcs:ToggleVisible(InviteHolder, ...) end
			return DiscordInvite
		end

		return Tab
	end

	CloseButton.Activated:Connect(function() Window:CloseBtn() end)
	MinimizeButton.Activated:Connect(function() Window:MinimizeBtn() end)
	return Window
end

return redzlib
