import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/review_model.dart';
import 'package:flutter/material.dart';

class HomeMockDatasource {
  HomeMockDatasource._();

  static List<ArtisanModel> getTopArtisans() => const [
    ArtisanModel(
      id: '1',
      name: 'Emeka Okafor',
      specialty: 'Master Plumber',
      rating: 4.9,
      reviews: 128,
      startingPrice: '₦3,500',
      isVerified: true,
      isOnline: true,
      badgeColor: AppColors.primaryLight,
      initials: 'EO',
      location: 'Lekki, Lagos',
      bio:
          'With over 8 years of experience, I specialise in residential and commercial plumbing. Quick diagnosis, clean work, and fair pricing are my hallmarks. I handle everything from blocked drains to full bathroom installations.',
      completedJobs: 342,
      todayOpenTime: '7:00 AM – 7:00 PM',
      isTodayOpen: true,
      responseTime: 'Typically < 1 hour',
      weeklySchedule: const {
        'Mon': '7:00 AM – 7:00 PM',
        'Tue': '7:00 AM – 7:00 PM',
        'Wed': '7:00 AM – 7:00 PM',
        'Thu': '7:00 AM – 7:00 PM',
        'Fri': '7:00 AM – 7:00 PM',
        'Sat': '9:00 AM – 3:00 PM',
        'Sun': null,
      },
    ),
    ArtisanModel(
      id: '2',
      name: 'Amina Bello',
      specialty: 'Electrician',
      rating: 4.8,
      reviews: 97,
      startingPrice: '₦4,000',
      isVerified: true,
      isOnline: false,
      badgeColor: AppColors.secondary,
      initials: 'AB',
      location: 'Ikeja, Lagos',
      bio:
          'Certified electrician with 6 years of expertise in installations, rewiring, and emergency callouts. Safety-first approach with transparent pricing. Available for both residential and commercial projects.',
      completedJobs: 278,
      todayOpenTime: '8:00 AM – 5:00 PM',
      isTodayOpen: false,
      responseTime: 'Usually 1–2 hours',
      weeklySchedule: const {
        'Mon': '8:00 AM – 5:00 PM',
        'Tue': '8:00 AM – 5:00 PM',
        'Wed': '8:00 AM – 5:00 PM',
        'Thu': '8:00 AM – 5:00 PM',
        'Fri': '8:00 AM – 5:00 PM',
        'Sat': null,
        'Sun': null,
      },
    ),
    ArtisanModel(
      id: '3',
      name: 'Chukwudi Nze',
      specialty: 'Carpenter',
      rating: 4.7,
      reviews: 63,
      startingPrice: '₦2,800',
      isVerified: false,
      isOnline: true,
      badgeColor: Color(0xFFFF9500),
      initials: 'CN',
      location: 'Surulere, Lagos',
      bio:
          'Custom furniture maker and repair specialist with 5 years in the craft. From fixing a broken chair to crafting bespoke wardrobes and kitchen cabinets, I bring wood to life with precision and care.',
      completedJobs: 195,
      todayOpenTime: '9:00 AM – 6:00 PM',
      isTodayOpen: true,
      responseTime: 'Same day',
      weeklySchedule: const {
        'Mon': null,
        'Tue': '9:00 AM – 6:00 PM',
        'Wed': '9:00 AM – 6:00 PM',
        'Thu': '9:00 AM – 6:00 PM',
        'Fri': '9:00 AM – 6:00 PM',
        'Sat': '9:00 AM – 6:00 PM',
        'Sun': null,
      },
    ),
    ArtisanModel(
      id: '4',
      name: 'Fatima Musa',
      specialty: 'House Cleaner',
      rating: 5.0,
      reviews: 214,
      startingPrice: '₦2,000',
      isVerified: true,
      isOnline: true,
      badgeColor: AppColors.primaryLight,
      initials: 'FM',
      location: 'Wuse II, Abuja',
      bio:
          'Professional cleaner with a keen eye for detail and 4 years of experience. I offer residential deep cleaning, post-construction cleanup, move-in/move-out services, and regular maintenance contracts.',
      completedJobs: 521,
      todayOpenTime: '6:00 AM – 4:00 PM',
      isTodayOpen: true,
      responseTime: 'Typically < 30 mins',
      weeklySchedule: const {
        'Mon': '6:00 AM – 4:00 PM',
        'Tue': '6:00 AM – 4:00 PM',
        'Wed': '6:00 AM – 4:00 PM',
        'Thu': '6:00 AM – 4:00 PM',
        'Fri': '6:00 AM – 4:00 PM',
        'Sat': '7:00 AM – 1:00 PM',
        'Sun': null,
      },
    ),
    ArtisanModel(
      id: '5',
      name: 'Tunde Adeyemi',
      specialty: 'Painter',
      rating: 4.6,
      reviews: 45,
      startingPrice: '₦3,200',
      isVerified: true,
      isOnline: false,
      badgeColor: AppColors.secondary,
      initials: 'TA',
      location: 'Victoria Island, Lagos',
      bio:
          'Interior and exterior painting specialist with 7 years delivering flawless finishes. I use premium paints, proper surface preparation, and meticulous technique to transform any space beautifully.',
      completedJobs: 156,
      todayOpenTime: '8:00 AM – 6:00 PM',
      isTodayOpen: false,
      responseTime: 'Within 24 hours',
      weeklySchedule: const {
        'Mon': '8:00 AM – 6:00 PM',
        'Tue': '8:00 AM – 6:00 PM',
        'Wed': '8:00 AM – 6:00 PM',
        'Thu': '8:00 AM – 6:00 PM',
        'Fri': '8:00 AM – 6:00 PM',
        'Sat': null,
        'Sun': null,
      },
    ),
  ];

  static List<String> getLocations() => const [
    'Lagos, Nigeria',
    'Abuja, Nigeria',
    'Port Harcourt, Nigeria',
    'Kano, Nigeria',
    'Ibadan, Nigeria',
    'Enugu, Nigeria',
  ];

  static List<ReviewModel> getReviewsForArtisan(String artisanId) {
    const allReviews = <String, List<ReviewModel>>{
      '1': [
        ReviewModel(
          id: 'r1a',
          reviewerName: 'Adaeze Obi',
          reviewerInitials: 'AO',
          avatarColor: Color(0xFF8B5CF6),
          rating: 5.0,
          comment:
              'Emeka fixed our burst pipe within an hour of calling. Very professional, kept everything clean, and explained what went wrong. Highly recommend!',
          timeAgo: '2 days ago',
        ),
        ReviewModel(
          id: 'r1b',
          reviewerName: 'Kofi Mensah',
          reviewerInitials: 'KM',
          avatarColor: Color(0xFFEC4899),
          rating: 5.0,
          comment:
              'Did a full bathroom installation for us. Arrived on time, completed the job ahead of schedule, and the finish was immaculate. Will definitely hire again.',
          timeAgo: '1 week ago',
        ),
        ReviewModel(
          id: 'r1c',
          reviewerName: 'Ngozi Eze',
          reviewerInitials: 'NE',
          avatarColor: Color(0xFFF59E0B),
          rating: 4.5,
          comment:
              'Great work unblocking our kitchen drain. A bit late to arrive but made up for it with the quality of work. Fair pricing too.',
          timeAgo: '2 weeks ago',
        ),
      ],
      '2': [
        ReviewModel(
          id: 'r2a',
          reviewerName: 'David Afolabi',
          reviewerInitials: 'DA',
          avatarColor: Color(0xFF0dd0f0),
          rating: 5.0,
          comment:
              'Amina upgraded our entire electrical panel safely and efficiently. She walked me through every step. Very knowledgeable and trustworthy.',
          timeAgo: '3 days ago',
        ),
        ReviewModel(
          id: 'r2b',
          reviewerName: 'Chioma Peters',
          reviewerInitials: 'CP',
          avatarColor: Color(0xFF22C55E),
          rating: 5.0,
          comment:
              'Fixed a tricky wiring fault that two other electricians couldn\'t diagnose. Amina found it in 20 minutes. Excellent work!',
          timeAgo: '5 days ago',
        ),
        ReviewModel(
          id: 'r2c',
          reviewerName: 'Yusuf Ibrahim',
          reviewerInitials: 'YI',
          avatarColor: Color(0xFFFF9500),
          rating: 4.5,
          comment:
              'Installed ceiling fans and outdoor security lights. Professional and clean work. Slightly pricey but worth every kobo.',
          timeAgo: '3 weeks ago',
        ),
      ],
      '3': [
        ReviewModel(
          id: 'r3a',
          reviewerName: 'Blessing Nwosu',
          reviewerInitials: 'BN',
          avatarColor: Color(0xFF8B5CF6),
          rating: 5.0,
          comment:
              'Chukwudi built us a custom wardrobe that perfectly fits our awkward bedroom alcove. The craftsmanship is exceptional. Looks brand new every day!',
          timeAgo: '1 week ago',
        ),
        ReviewModel(
          id: 'r3b',
          reviewerName: 'Samuel Osei',
          reviewerInitials: 'SO',
          avatarColor: Color(0xFFEC4899),
          rating: 4.5,
          comment:
              'Repaired our dining table and fixed several loose door frames. Quick turnaround and very reasonable price.',
          timeAgo: '2 weeks ago',
        ),
        ReviewModel(
          id: 'r3c',
          reviewerName: 'Hauwa Danladi',
          reviewerInitials: 'HD',
          avatarColor: Color(0xFF0dd0f0),
          rating: 4.5,
          comment:
              'Made custom shelves for our home office. Excellent quality wood and very neat finishing. Highly recommended for bespoke furniture.',
          timeAgo: '1 month ago',
        ),
      ],
      '4': [
        ReviewModel(
          id: 'r4a',
          reviewerName: 'James Okafor',
          reviewerInitials: 'JO',
          avatarColor: Color(0xFFF59E0B),
          rating: 5.0,
          comment:
              'Fatima did a deep clean of our 4-bedroom house before our housewarming. The place was spotless! She is thorough, fast, and very professional.',
          timeAgo: '1 day ago',
        ),
        ReviewModel(
          id: 'r4b',
          reviewerName: 'Lara Adewale',
          reviewerInitials: 'LA',
          avatarColor: Color(0xFF22C55E),
          rating: 5.0,
          comment:
              'We hired Fatima for weekly cleaning. She is always on time, uses quality products, and never misses a spot. Absolute 5 stars!',
          timeAgo: '4 days ago',
        ),
        ReviewModel(
          id: 'r4c',
          reviewerName: 'Emeka Agu',
          reviewerInitials: 'EA',
          avatarColor: Color(0xFF8B5CF6),
          rating: 5.0,
          comment:
              'Post-construction cleanup after our renovation. Fatima\'s team left the house looking like a show home. Outstanding work!',
          timeAgo: '1 week ago',
        ),
      ],
      '5': [
        ReviewModel(
          id: 'r5a',
          reviewerName: 'Sola Adeyemi',
          reviewerInitials: 'SA',
          avatarColor: Color(0xFFEC4899),
          rating: 5.0,
          comment:
              'Tunde painted our entire living and dining area. The colour match was perfect and the edges are razor sharp. Very impressive finish.',
          timeAgo: '5 days ago',
        ),
        ReviewModel(
          id: 'r5b',
          reviewerName: 'Grace Okonkwo',
          reviewerInitials: 'GO',
          avatarColor: Color(0xFFFF9500),
          rating: 4.5,
          comment:
              'Did the exterior walls of our apartment block. Neat, durable work. He came with proper equipment and scaffolding. Great job!',
          timeAgo: '2 weeks ago',
        ),
        ReviewModel(
          id: 'r5c',
          reviewerName: 'Musa Bello',
          reviewerInitials: 'MB',
          avatarColor: Color(0xFF0dd0f0),
          rating: 4.5,
          comment:
              'Created a beautiful feature accent wall in our bedroom. The design was exactly as I requested. Very creative and skilled.',
          timeAgo: '1 month ago',
        ),
      ],
    };
    return allReviews[artisanId] ?? [];
  }
}
