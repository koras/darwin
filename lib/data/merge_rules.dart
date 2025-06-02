import 'package:darwin/data/merge_rule.dart';

final List<MergeRule> mergeRules = [
  //Природные элементы и стихии
  MergeRule('water', 'water', 'sea'),
  MergeRule('water', 'earth', 'swamp'),
  MergeRule('water', 'fire', 'steam'),
  MergeRule('water', 'wind', 'cloud'),
  MergeRule('earth', 'earth', 'mountain'),
  MergeRule('earth', 'fire', 'lava'),
  MergeRule('fire', 'fire', 'volcano'),
  MergeRule('fire', 'wind', 'lightning'),
  MergeRule('cloud', 'cloud', 'sky'),
  MergeRule('sky', 'lightning', 'storm'),
  MergeRule('mountain', 'snow', 'glacier'),
  MergeRule('sand', 'wind', 'sand_mountain'),
  // Флора и фауна
  MergeRule('earth', 'water', 'bacteria'),
  MergeRule('bacteria', 'time', 'plankton'),
  MergeRule('plankton', 'water', 'fish'),
  MergeRule('fish', 'earth', 'mammal'),
  MergeRule('mammal', 'mountain', 'dragon'),
  MergeRule('mammal', 'swamp', 'frog'),
  MergeRule('fish', 'time', 'dolphin'),
  MergeRule('tree', 'tree', 'forest'),
  MergeRule('flower', 'flower', 'garden'),
  MergeRule('bee', 'flower', 'honey'),
  MergeRule('bird', 'fire', 'phoenix'),
  MergeRule('lizard', 'fire', 'dragon'),
  // Человек и цивилизация
  MergeRule('man', 'stone', 'tool'),
  MergeRule('tool', 'wood', 'house_in_the_village'),
  MergeRule('house_in_the_village', 'house_in_the_village', 'village'),
  MergeRule('village', 'village', 'city'),
  MergeRule('city', 'city', 'metropolis'),
  MergeRule('man', 'man', 'family'),
  MergeRule('family', 'family', 'crowd_of_people'),
  MergeRule('crowd_of_people', 'alcohol', 'noisy_friday_party'),
  MergeRule('man', 'sword', 'knight'),
  MergeRule('knight', 'dragon', 'hero'),
  MergeRule('man', 'book', 'scientist'),
  // Технологии и изобретения
  MergeRule('wheel', 'wood', 'cart'),
  MergeRule('cart', 'horse', 'carriage'),
  MergeRule('steam', 'metal', 'train'),
  MergeRule('metal', 'fire', 'sword'),
  MergeRule('wood', 'cloth', 'sailing_ship'),
  MergeRule('engine', 'carriage', 'car'),
  MergeRule('car', 'wings', 'plane'),
  MergeRule('electricity', 'metal', 'robot'),
  MergeRule('computer', 'robot', 'artificial_intelligence'),
  MergeRule('phone', 'wireless', 'smartphone'),
  MergeRule('rocket', 'satellite', 'spaceship'),
  // Еда и напитки
  MergeRule('grape', 'time', 'wine'),
  MergeRule('wine', 'man', 'sommelier'),
  MergeRule('milk', 'bacteria', 'cheese'),
  MergeRule('flour', 'water', 'dough'),
  MergeRule('dough', 'fire', 'bread'),
  MergeRule('bread', 'meat', 'burger'),
  MergeRule('coffee', 'water', 'americano'),
  MergeRule('fruit', 'sugar', 'jam'),
  MergeRule('wheat', 'stone', 'flour'),
  MergeRule('honey', 'water', 'mead'),

  //  Мифология и фэнтези
  MergeRule('unicorn', 'rainbow', 'magic'),
  MergeRule('dragon', 'man', 'knight'),
  MergeRule('knight', 'dragon', 'hero'),
  MergeRule('sword', 'stone', 'excalibur'),
  MergeRule('wizard', 'school', 'hogwarts_school'),
  MergeRule('ghost', 'energy', 'poltergeist'),
  MergeRule('vampire', 'bat', 'dracula'),
  MergeRule('werewolf', 'silver', 'cursed'),
  // Погода и атмосферные явления
  MergeRule('cloud', 'water', 'rain'),
  MergeRule('rain', 'sun', 'rainbow'),
  MergeRule('cloud', 'electricity', 'thunderstorm'),
  MergeRule('wind', 'water', 'tornado'),
  MergeRule('cold', 'water', 'snow'),
  MergeRule('snow', 'man', 'snowman'),
  MergeRule('steam', 'cold', 'frost'),
  MergeRule('sand', 'wind', 'sandstorm'),
  MergeRule('lava', 'water', 'obsidian'),
  // 8. Наука и медицина
  MergeRule('dna', 'bacteria', 'virus'),
  MergeRule('microscope', 'bacteria', 'antibiotic'),
  MergeRule('radiation', 'cells', 'mutation'),
  MergeRule('chemicals', 'lab', 'medicine'),
  MergeRule('brain', 'computer', 'ai'),
  MergeRule('electricity', 'nerves', 'stimulus'),
  MergeRule('xray', 'bone', 'diagnosis'),
  // Праздники и события
  MergeRule('man', 'gift', 'santa'),
  MergeRule('tree', 'decorations', 'christmas_tree'),
  MergeRule('cake', 'candles', 'birthday'),
  MergeRule('fire', 'sky', 'fireworks'),
  MergeRule('costume', 'party', 'halloween'),
  MergeRule('champagne', 'night', 'new_year'),
  // Мемы и поп-культура
  MergeRule('cat', 'boots', 'puss_in_boots'),
  MergeRule('man', 'hammer', 'thor'),
  MergeRule('dragon', 'woman', 'daenerys'),
  MergeRule('wizard', 'school', 'hogwarts'),
  MergeRule('zombie', 'pandemic', 'walking_dead'),
  MergeRule('shark', 'nike', 'shark_and_nike'),
  MergeRule('bear', 'bicycle', 'circus_bear'),
  MergeRule('student', 'coffee', 'zombie'), // Для мема "студент на сессии")
  // Космос и футуризм
  MergeRule('rocket', 'satellite', 'space_station'),
  MergeRule('metal', 'star', 'death_star'),
  MergeRule('astronaut', 'alien', 'first_contact'),
  MergeRule('energy', 'crystal', 'lightsaber'),
  MergeRule('spaceship', 'city', 'coruscant'),
  MergeRule('robot', 'human', 'cyborg'),
  MergeRule('black_hole', 'time', 'wormhole'),
  MergeRule('ai', 'internet', 'singularity'),
  // Магия и алхимия
  MergeRule('potion', 'feather', 'levitation'),
  MergeRule('crystal', 'energy', 'spellbook'),
  MergeRule('wand', 'dragon_heartstring', 'elder_wand'),
  MergeRule('philosopher_stone', 'lead', 'gold'),
  MergeRule('moonlight', 'flower', 'potion_of_invisibility'),
  MergeRule('vampire', 'werewolf', 'hybrid'),
  MergeRule('necronomicon', 'blood', 'summoning'),
  MergeRule('fairy', 'dust', 'pixie'),
  // Транспорт и машины
  MergeRule('engine', 'bicycle', 'motorcycle'),
  MergeRule('car', 'boat', 'amphibious_vehicle'),
  MergeRule('helicopter', 'submarine', 'osprey'),
  MergeRule('wings', 'engine', 'jetpack'),
  MergeRule('hoverboard', 'antigravity', 'flying_car'),
  MergeRule('train', 'rocket', 'hyperloop'),
  MergeRule('sail', 'solar_panel', 'eco_ship'),
  MergeRule('truck', 'robot', 'transformer'),
  //  Арктика и антарктика
  MergeRule('ice', 'bear', 'polar_bear'),
  MergeRule('penguin', 'suit', 'explorer'),
  MergeRule('glacier', 'sailing_ship', 'titanic'),
  MergeRule('blubber', 'lamp', 'oil_lamp'),
  MergeRule('kayak', 'harpoon', 'whale_hunter'),
  // Подводный мир
  MergeRule('submarine', 'fish', 'aquarium'),
  MergeRule('pearl', 'oyster', 'treasure'),
  MergeRule('coral', 'stone', 'reef'),
  MergeRule('deep', 'pressure', 'bathyscaphe'),
  MergeRule('mermaid', 'net', 'captured_dream'),
  MergeRule('leviathan', 'ship', 'kraken_attack'),
  MergeRule('algae', 'light', 'underwater_farm'),
  MergeRule('sunken', 'city', 'atlantis'),
  // Средневековье и фэнтези-мир
  MergeRule('castle', 'dragon', 'siege'),
  MergeRule('alchemist', 'laboratory', 'elixir'),
  MergeRule('runes', 'weapon', 'enchanted_sword'),
  MergeRule('tavern', 'rumor', 'quest'),
  MergeRule('prophecy', 'hero', 'chosen_one'),
  MergeRule('golem', 'clay', 'guardian'),
  MergeRule('scroll', 'temple', 'ancient_knowledge'),
  MergeRule('minotaur', 'labyrinth', 'trap'),
  // Киберпанк и будущее
  MergeRule('neon', 'rain', 'blade_runner_scene'),
  MergeRule('hacker', 'ai', 'matrix'),
  MergeRule('cybereye', 'internet', 'augmented_reality'),
  MergeRule('drone', 'swarm', 'surveillance_system'),
  MergeRule('nanobots', 'blood', 'healing_factor'),
  MergeRule('corporate', 'dystopia', 'megacorp'),
  MergeRule('virtual', 'reality', 'full_dive'),
  MergeRule('robot', 'rights', 'rebellion'),
  // Древние цивилизации
  MergeRule('pyramid', 'alien', 'ancient_astronaut'),
  MergeRule('obelisk', 'energy', 'power_source'),
  MergeRule('hieroglyph', 'translation', 'lost_history'),
  MergeRule('mummy', 'curse', 'revenant'),
  MergeRule('artifact', 'museum', 'indiana_jones'),
  MergeRule('stonehenge', 'alignment', 'celestial_event'),
  MergeRule('scroll', 'library', 'alexandria'),
  MergeRule('chariot', 'sun', 'solar_deity'),
  // Катастрофы и апокалипсис
  MergeRule('asteroid', 'earth', 'dinosaur_extinction'),
  MergeRule('virus', 'global', 'pandemic'),
  MergeRule('nuke', 'city', 'post_apocalypse'),
  MergeRule('climate', 'collapse', 'waterworld'),
  MergeRule('ai', 'war', 'skynet'),
  MergeRule('zombie', 'outbreak', 'last_of_us'),
  MergeRule('supervolcano', 'winter', 'ice_age'),
  MergeRule('black_hole', 'lab', 'accident'),
  // Искусство и творчество
  MergeRule('paint', 'madness', 'starry_night'),
  MergeRule('marble', 'chisel', 'statue'),
  MergeRule('stage', 'tragedy', 'hamlet'),
  MergeRule('camera', 'dream', 'surrealism'),
  MergeRule('jazz', 'whiskey', 'blues'),
  MergeRule('graffiti', 'rebellion', 'street_art'),
  MergeRule('words', 'passion', 'poetry'),
  MergeRule('dance', 'fire', 'ritual'),
  // Космические правила
  MergeRule('star', 'dust', 'nebula'),
  MergeRule('planet', 'ring', 'saturn'),
  MergeRule('spacesuit', 'alien', 'xenoarchaeologist'),

  // Магические комбинации
  MergeRule('crystal_ball', 'smoke', 'prophecy'),
  MergeRule('toad', 'cauldron', 'potion'),
  MergeRule('voodoo', 'doll', 'curse'),

  // Техно-комбинации
  MergeRule('quantum', 'computer', 'time_machine'),
  MergeRule('nanotech', 'skin', 'invisibility_suit'),
  MergeRule('hologram', 'touch', 'hardlight'),

  // Особые секретные комбинации
  MergeRule('konami', 'code', 'secret_weapon'), // Easter egg
  MergeRule('dev', 'password', 'unlock_all'), // Для тестирования
  MergeRule('infinity', 'gauntlet', 'snap'), // Для фанатов Marvel
  // Для создания философского камня:
  MergeRule('mercury', 'sulfur', 'prima_materia'),
  MergeRule('prima_materia', 'moonlight', 'white_elixir'),
  MergeRule('white_elixir', 'sunlight', 'philosopher_stone'),

  // Создание дракона:
  MergeRule('lizard', 'fire', 'dragon'),
  MergeRule('dinosaur', 'magic', 'dragon'),
  MergeRule('snake', 'feathers', 'aztec_dragon'),
  // Меняющиеся комбинации:
  MergeRule('season', 'time', 'next_season'), // Цикл
  MergeRule('day', 'night', 'full_cycle'),

  // Химия/Физика
  MergeRule('hydrogen', 'oxygen', 'water'), // H₂O
  MergeRule('carbon', 'pressure', 'diamond'),
  MergeRule('uranium', 'neutron', 'nuclear_reaction'),
  MergeRule('lightning', 'sand', 'glass'),
  MergeRule('mercury', 'aluminum', 'thermite'), // Реакция с выделением тепла
  // Биология
  MergeRule('dna', 'virus', 'vaccine'),
  MergeRule('frog', 'radiation', 'giant_monster'), // Отсылка к 1950s B-movies
  MergeRule('bacteria', 'antibiotic', 'superbug'), // Устойчивость
  MergeRule('neuron', 'chip', 'neural_interface'),

  // Технологии
  MergeRule('ai', 'quantum', 'singularity'),
  MergeRule('robot', 'law', 'three_laws'), // Законы робототехники
  MergeRule('bitcoin', 'energy', 'carbon_footprint'),

  // Marvel
  MergeRule('spider', 'radioactivity', 'spiderman'),
  MergeRule('iron', 'genius', 'iron_man'),
  MergeRule('infinity_stones', 'gauntlet', 'thanos_snap'),

  // DC
  MergeRule('bat', 'trauma', 'batman'),
  MergeRule('kryptonite', 'superman', 'weakness'),

  // Классика кино
  MergeRule('shark', 'beach', 'jaws'),
  MergeRule('dinosaurs', 'dna', 'jurassic_park'),
  MergeRule('ring', 'videotape', 'sadako'), // «Звонок»
  // Игры
  MergeRule('plumber', 'mushroom', 'mario'),
  MergeRule('block', 'pickaxe', 'minecraft'),
  MergeRule('zombie', 'plants', 'lawnmower'), // Plants vs Zombies
  // Интернет-мемы
  MergeRule('banana', 'scale', 'banana_for_scale'),
  MergeRule('dog', 'cheems', 'doge'),
  MergeRule('avocado', 'toast', 'millennial_crisis'),

  // Неожиданные комбинации
  MergeRule('philosopher', 'stone', 'harry_potter'), // Умышленная путаница
  MergeRule('nothing', 'nothing', 'something'), // Парадокс
  MergeRule('cat', 'keyboard', 'cat_meme_2025'),

  // Для фанатов абсурда
  MergeRule('flat_earth', 'rocket', 'space_denial'),
  MergeRule('conspiracy', 'coffee', 'wake_up_sheeple'),

  // Космоопера
  MergeRule('warp', 'engine', 'ftl_drive'), // Сверхсветовой двигатель
  MergeRule('lightsaber', 'kyber', 'death_star_beam'),

  // Магия
  MergeRule('unicorn', 'blood', 'dark_ritual'), // Игра с тропами
  MergeRule('wizard', 'hat', 'hogwarts_letter'),

  // Киберпанк
  MergeRule('brain', 'internet', 'mind_upload'),
  MergeRule('corpo', 'dystopia', 'night_city'),
  // Классическая алхимия
  MergeRule('lead', 'philosopher_stone', 'gold'),
  MergeRule('mandrake', 'silver_knife', 'homunculus'),

  // Мифы
  MergeRule('apple', 'discord', 'troyan_war'), // Яблоко раздора
  MergeRule('pandora', 'box', 'all_evils'),
  MergeRule('minotaur', 'thread', 'escape'), // Нить Ариадны
  // Исторические артефакты
  MergeRule('sand', 'time', 'hourglass'),
  MergeRule('ivory', 'black_market', 'blood_diamond'),
];
