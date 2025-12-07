import 'package:mobile_computing_capstone/database/database_helper.dart';
import 'package:mobile_computing_capstone/models/job.dart';

class DatabaseSeeder {
  static Future<void> seedJobs() async {
    final db = DatabaseHelper.instance;

    // Check if jobs already exist
    final existingJobs = await db.getAllJobs();
    if (existingJobs.isNotEmpty) {
      print('Database already seeded with ${existingJobs.length} jobs');
      return;
    }

    final jobs = _generateFakeJobs();

    for (var job in jobs) {
      await db.insertJob(job);
    }

    print('Successfully seeded ${jobs.length} jobs into database');
  }

  static List<Job> _generateFakeJobs() {
    return [
      // Sales Positions
      Job(
        title: 'Sales Associate',
        company: 'RetailMax Store',
        description:
            'Join our dynamic sales team! Help customers find the perfect products, process transactions, and maintain store appearance. Great for people-oriented individuals who enjoy retail.',
        salary: 35000,
        tags: '"Sales","Retail","Customer Service","Part-time"',
        applyUrl: 'https://retailmax.com/careers/sales',
      ),
      Job(
        title: 'Account Executive',
        company: 'CloudSoft Solutions',
        description:
            'Sell enterprise software solutions to mid-market companies. Build relationships, conduct demos, and close deals. Strong commission structure with base salary.',
        salary: 75000,
        tags: '"Sales","B2B","Software","Account Management"',
        applyUrl: 'https://cloudsoft.com/jobs/ae',
      ),
      Job(
        title: 'Real Estate Agent',
        company: 'Premier Properties Group',
        description:
            'Help clients buy and sell homes. Flexible schedule, unlimited earning potential through commissions. Training and mentorship provided for new agents.',
        salary: 45000,
        tags: '"Real Estate","Sales","Commission","Flexible"',
        applyUrl: 'https://premierproperties.com/careers',
      ),
      Job(
        title: 'Car Sales Consultant',
        company: 'AutoNation Dealership',
        description:
            'Sell new and used vehicles. Meet with customers, test drives, financing options. Competitive pay with bonuses and benefits.',
        salary: 42000,
        tags: '"Automotive","Sales","Customer Service","Commission"',
        applyUrl: 'https://autonation.com/jobs',
      ),

      // Food Service Positions
      Job(
        title: 'Server',
        company: 'The Olive Garden',
        description:
            'Provide excellent dining experiences to guests. Take orders, serve food and beverages, ensure customer satisfaction. Flexible shifts available.',
        salary: 28000,
        tags: '"Food Service","Server","Hospitality","Tips"',
        applyUrl: 'https://olivegarden.com/careers',
      ),
      Job(
        title: 'Line Cook',
        company: 'Downtown Bistro',
        description:
            'Prepare dishes according to recipes and standards. Work in fast-paced kitchen environment. Experience with various cooking techniques preferred.',
        salary: 38000,
        tags: '"Culinary","Cooking","Kitchen","Food Prep"',
        applyUrl: 'https://downtownbistro.com/jobs',
      ),
      Job(
        title: 'Barista',
        company: 'Starbucks Coffee',
        description:
            'Craft beverages, serve customers, maintain clean workspace. Create memorable customer experiences. Benefits include health insurance and stock options.',
        salary: 32000,
        tags: '"Barista","Coffee","Customer Service","Food Service"',
        applyUrl: 'https://starbucks.com/careers',
      ),
      Job(
        title: 'Restaurant Manager',
        company: 'Buffalo Wild Wings',
        description:
            'Oversee daily restaurant operations, manage staff, ensure food quality and customer satisfaction. Previous management experience required.',
        salary: 55000,
        tags: '"Management","Food Service","Leadership","Operations"',
        applyUrl: 'https://buffalowildwings.com/jobs',
      ),
      Job(
        title: 'Sous Chef',
        company: 'Fine Dining Restaurant',
        description:
            'Support head chef in kitchen management, food preparation, and staff supervision. Create innovative dishes and maintain high culinary standards.',
        salary: 52000,
        tags: '"Culinary","Chef","Kitchen Management","Fine Dining"',
        applyUrl: 'https://finedining.com/careers',
      ),
      Job(
        title: 'Fast Food Crew Member',
        company: 'McDonald\'s',
        description:
            'Prepare food, take orders, maintain cleanliness. Fast-paced environment with opportunities for advancement. Flexible scheduling for students.',
        salary: 26000,
        tags: '"Fast Food","Customer Service","Entry Level","Flexible"',
        applyUrl: 'https://mcdonalds.com/careers',
      ),

      // Management Positions
      Job(
        title: 'Store Manager',
        company: 'Target Corporation',
        description:
            'Lead store operations, manage team of 50+ employees, drive sales goals, and ensure excellent customer experience. Retail management experience required.',
        salary: 65000,
        tags: '"Management","Retail","Leadership","Operations"',
        applyUrl: 'https://target.com/careers/store-manager',
      ),
      Job(
        title: 'Project Manager',
        company: 'Construction Plus Inc',
        description:
            'Manage construction projects from start to finish. Coordinate with contractors, manage budgets and timelines, ensure safety compliance.',
        salary: 82000,
        tags: '"Project Management","Construction","Leadership","Planning"',
        applyUrl: 'https://constructionplus.com/jobs',
      ),
      Job(
        title: 'Office Manager',
        company: 'Anderson & Associates',
        description:
            'Oversee administrative functions, manage office staff, coordinate schedules, handle budgets and supplies. Organizational skills essential.',
        salary: 48000,
        tags:
            '"Office Management","Administration","Organization","Leadership"',
        applyUrl: 'https://anderson-associates.com/careers',
      ),
      Job(
        title: 'Operations Manager',
        company: 'Warehouse Solutions LLC',
        description:
            'Manage warehouse operations, optimize logistics, supervise staff, implement efficiency improvements. Experience with inventory systems required.',
        salary: 72000,
        tags: '"Operations","Management","Logistics","Warehouse"',
        applyUrl: 'https://warehousesolutions.com/jobs',
      ),
      Job(
        title: 'General Manager',
        company: 'Fitness First Gym',
        description:
            'Oversee all aspects of gym operations including sales, member services, staff management, and facility maintenance. Passion for fitness required.',
        salary: 58000,
        tags: '"Management","Fitness","Operations","Customer Service"',
        applyUrl: 'https://fitnessfirst.com/careers',
      ),

      // Development/Tech Positions
      Job(
        title: 'Frontend Developer',
        company: 'WebCraft Studios',
        description:
            'Build responsive websites using React, JavaScript, and modern CSS. Work with designers to create beautiful user interfaces.',
        salary: 78000,
        tags: '"Frontend","React","JavaScript","Web Development"',
        applyUrl: 'https://webcraft.com/jobs/frontend',
      ),
      Job(
        title: 'Full Stack Developer',
        company: 'TechStart Inc',
        description:
            'Develop web applications using Node.js, React, and MongoDB. Build both client and server-side features. Startup environment with equity.',
        salary: 95000,
        tags: '"Full Stack","Node.js","React","Startup"',
        applyUrl: 'https://techstart.com/careers',
      ),
      Job(
        title: 'Python Developer',
        company: 'Data Analytics Corp',
        description:
            'Write Python code for data processing and analysis. Work with Django, data science libraries, and APIs. Strong analytical skills needed.',
        salary: 88000,
        tags: '"Python","Backend","Data Analysis","Django"',
        applyUrl: 'https://dataanalytics.com/jobs',
      ),
      Job(
        title: 'DevOps Engineer',
        company: 'CloudNative Solutions',
        description:
            'Manage CI/CD pipelines, cloud infrastructure, and deployment automation. Experience with AWS, Docker, and Kubernetes required.',
        salary: 102000,
        tags: '"DevOps","AWS","Docker","Cloud"',
        applyUrl: 'https://cloudnative.com/careers',
      ),
      Job(
        title: 'Junior Software Developer',
        company: 'CodeAcademy Tech',
        description:
            'Entry-level position for recent graduates. Learn from experienced developers while building real applications. Training provided.',
        salary: 62000,
        tags: '"Software Development","Junior","Entry Level","Training"',
        applyUrl: 'https://codeacademy.com/jobs',
      ),

      // Art & Design Positions
      Job(
        title: 'Graphic Designer',
        company: 'Creative Agency Studio',
        description:
            'Design marketing materials, logos, and brand identities. Proficiency in Adobe Creative Suite required. Build portfolio with diverse projects.',
        salary: 52000,
        tags: '"Graphic Design","Adobe","Creative","Marketing"',
        applyUrl: 'https://creativeagency.com/careers',
      ),
      Job(
        title: 'UI/UX Designer',
        company: 'DigitalFlow Apps',
        description:
            'Design user interfaces and experiences for mobile and web applications. Conduct user research, create wireframes and prototypes using Figma.',
        salary: 72000,
        tags: '"UI/UX","Design","Figma","User Experience"',
        applyUrl: 'https://digitalflow.com/jobs',
      ),
      Job(
        title: 'Art Director',
        company: 'BrandVision Marketing',
        description:
            'Lead creative team, develop visual concepts for campaigns, manage multiple projects. 5+ years design experience required.',
        salary: 85000,
        tags: '"Art Direction","Leadership","Creative","Marketing"',
        applyUrl: 'https://brandvision.com/careers',
      ),
      Job(
        title: 'Illustrator',
        company: 'Children\'s Book Publishers',
        description:
            'Create illustrations for children\'s books and educational materials. Digital and traditional art skills welcomed. Portfolio review required.',
        salary: 48000,
        tags: '"Illustration","Art","Digital Art","Publishing"',
        applyUrl: 'https://childrenbooks.com/jobs',
      ),
      Job(
        title: '3D Artist',
        company: 'GameDev Studios',
        description:
            'Create 3D models, textures, and animations for video games. Experience with Maya, Blender, or 3ds Max. Work on exciting game projects.',
        salary: 68000,
        tags: '"3D Art","Game Development","Modeling","Animation"',
        applyUrl: 'https://gamedev.com/careers',
      ),
      Job(
        title: 'Photographer',
        company: 'Portrait Studio Pro',
        description:
            'Capture professional portraits, family photos, and events. Edit photos, manage client relationships. Own equipment preferred.',
        salary: 42000,
        tags: '"Photography","Portrait","Creative","Freelance"',
        applyUrl: 'https://portraitstudio.com/jobs',
      ),

      // Healthcare Positions
      Job(
        title: 'Registered Nurse',
        company: 'City General Hospital',
        description:
            'Provide patient care in hospital setting. Administer medications, monitor vital signs, collaborate with medical team. RN license required.',
        salary: 72000,
        tags: '"Healthcare","Nursing","Medical","Patient Care"',
        applyUrl: 'https://cityhospital.com/careers',
      ),
      Job(
        title: 'Medical Assistant',
        company: 'Family Care Clinic',
        description:
            'Support physicians with patient care, take vital signs, prepare exam rooms, schedule appointments. Certification preferred.',
        salary: 38000,
        tags: '"Healthcare","Medical Assistant","Patient Care","Clinical"',
        applyUrl: 'https://familycare.com/jobs',
      ),
      Job(
        title: 'Physical Therapist',
        company: 'Rehab Center Plus',
        description:
            'Help patients recover from injuries through exercise and therapy. Develop treatment plans, track progress. PT license required.',
        salary: 78000,
        tags: '"Healthcare","Physical Therapy","Rehabilitation","Medical"',
        applyUrl: 'https://rehabcenter.com/careers',
      ),

      // Education Positions
      Job(
        title: 'Elementary School Teacher',
        company: 'Lincoln Elementary School',
        description:
            'Teach grades K-5, develop lesson plans, assess student progress. Create engaging learning environment. Teaching certification required.',
        salary: 52000,
        tags: '"Education","Teaching","Elementary","K-12"',
        applyUrl: 'https://lincolnschool.com/jobs',
      ),
      Job(
        title: 'Tutor',
        company: 'Learning Center Academy',
        description:
            'Provide one-on-one tutoring in math, science, and English. Help students improve grades and test scores. Flexible part-time hours.',
        salary: 32000,
        tags: '"Education","Tutoring","Part-time","Teaching"',
        applyUrl: 'https://learningcenter.com/careers',
      ),
      Job(
        title: 'University Professor',
        company: 'State University',
        description:
            'Teach undergraduate courses, conduct research, publish academic papers. PhD in relevant field required. Tenure-track position.',
        salary: 95000,
        tags: '"Education","Professor","Research","University"',
        applyUrl: 'https://stateuniversity.com/faculty',
      ),

      // Trades & Technical
      Job(
        title: 'Electrician',
        company: 'Power Systems Electric',
        description:
            'Install and repair electrical systems in residential and commercial buildings. Journeyman license preferred. Company vehicle provided.',
        salary: 62000,
        tags: '"Electrical","Trade","Construction","Technical"',
        applyUrl: 'https://powersystems.com/jobs',
      ),
      Job(
        title: 'Plumber',
        company: 'A1 Plumbing Services',
        description:
            'Install and repair plumbing systems. Emergency calls, residential service. License required. Competitive pay with benefits.',
        salary: 58000,
        tags: '"Plumbing","Trade","Construction","Repair"',
        applyUrl: 'https://a1plumbing.com/careers',
      ),
      Job(
        title: 'HVAC Technician',
        company: 'Climate Control Solutions',
        description:
            'Install, maintain, and repair heating and cooling systems. Certification required. Year-round work with overtime opportunities.',
        salary: 55000,
        tags: '"HVAC","Trade","Technical","Repair"',
        applyUrl: 'https://climatecontrol.com/jobs',
      ),
      Job(
        title: 'Auto Mechanic',
        company: 'QuickFix Auto Repair',
        description:
            'Diagnose and repair vehicles. Perform routine maintenance, engine work, and inspections. ASE certification preferred.',
        salary: 48000,
        tags: '"Automotive","Mechanic","Repair","Technical"',
        applyUrl: 'https://quickfix.com/careers',
      ),

      // Customer Service
      Job(
        title: 'Customer Service Representative',
        company: 'TechSupport Solutions',
        description:
            'Answer customer inquiries via phone, email, and chat. Resolve technical issues, process orders. Training provided. Remote work available.',
        salary: 38000,
        tags: '"Customer Service","Remote","Support","Communication"',
        applyUrl: 'https://techsupport.com/jobs',
      ),
      Job(
        title: 'Call Center Agent',
        company: 'National Insurance Group',
        description:
            'Handle inbound calls, answer questions about insurance policies, process claims. Full-time with benefits. Bilingual Spanish a plus.',
        salary: 35000,
        tags: '"Call Center","Customer Service","Insurance","Bilingual"',
        applyUrl: 'https://nationalinsurance.com/careers',
      ),

      // Finance & Accounting
      Job(
        title: 'Accountant',
        company: 'Smith & Partners CPA',
        description:
            'Prepare financial statements, manage accounts, conduct audits. CPA certification preferred. Work with diverse client base.',
        salary: 68000,
        tags: '"Accounting","Finance","CPA","Tax"',
        applyUrl: 'https://smithcpa.com/jobs',
      ),
      Job(
        title: 'Financial Advisor',
        company: 'Wealth Management Group',
        description:
            'Help clients plan investments, retirement, and financial goals. Build client relationships, provide expert advice. License required.',
        salary: 72000,
        tags: '"Finance","Advisor","Investment","Sales"',
        applyUrl: 'https://wealthmanagement.com/careers',
      ),
      Job(
        title: 'Bookkeeper',
        company: 'Small Business Services',
        description:
            'Manage accounts payable/receivable, reconcile bank statements, prepare reports. QuickBooks experience required. Part-time available.',
        salary: 42000,
        tags: '"Bookkeeping","Accounting","QuickBooks","Part-time"',
        applyUrl: 'https://smallbizservices.com/jobs',
      ),

      // Transportation & Logistics
      Job(
        title: 'Delivery Driver',
        company: 'Amazon Logistics',
        description:
            'Deliver packages to customers. Use company van, follow delivery routes. Physical work, lifting required. Benefits included.',
        salary: 40000,
        tags: '"Delivery","Driving","Logistics","Physical"',
        applyUrl: 'https://amazon.com/driver-jobs',
      ),
      Job(
        title: 'Truck Driver (CDL)',
        company: 'Interstate Freight Lines',
        description:
            'Long-haul trucking position. CDL Class A required. Competitive pay, good benefits, home time guaranteed. Experienced drivers preferred.',
        salary: 65000,
        tags: '"Trucking","CDL","Logistics","Transportation"',
        applyUrl: 'https://interstatefreight.com/careers',
      ),

      // Marketing & Communications
      Job(
        title: 'Marketing Coordinator',
        company: 'BrandBoost Agency',
        description:
            'Coordinate marketing campaigns, manage social media, create content. Work with creative team to execute strategies.',
        salary: 48000,
        tags: '"Marketing","Social Media","Content","Communications"',
        applyUrl: 'https://brandboost.com/jobs',
      ),
      Job(
        title: 'Content Writer',
        company: 'Digital Media Company',
        description:
            'Write blog posts, articles, and web content. Research topics, optimize for SEO. Portfolio of writing samples required.',
        salary: 52000,
        tags: '"Writing","Content","SEO","Marketing"',
        applyUrl: 'https://digitalmedia.com/careers',
      ),
      Job(
        title: 'Social Media Manager',
        company: 'Influencer Marketing Hub',
        description:
            'Manage social media accounts for multiple clients. Create content calendars, engage with followers, analyze metrics.',
        salary: 55000,
        tags: '"Social Media","Marketing","Content Creation","Analytics"',
        applyUrl: 'https://influencerhub.com/jobs',
      ),
    ];
  }
}
