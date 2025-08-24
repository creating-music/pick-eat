import '../models/category.dart';
import '../models/menu.dart';
import '../models/preference.dart';
import '../models/dislike_category.dart';
import 'menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final List<Menu> _menus = [
    // 패스트푸드
    Menu(
      id: '1',
      name: '햄버거',
      category: Category.fastFood,
      preference: PreferenceCategory.fastFood,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '2',
      name: '치킨',
      category: Category.fastFood,
      preference: PreferenceCategory.fastFood,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.chicken,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '3',
      name: '피자',
      category: Category.fastFood,
      preference: PreferenceCategory.fastFood,
      dislikes: [DislikeCategory.greasy, DislikeCategory.warm],
    ),
    Menu(
      id: '4',
      name: '핫도그',
      category: Category.fastFood,
      preference: PreferenceCategory.fastFood,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.pork,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),

    // 양식/멕시칸
    Menu(
      id: '5',
      name: '파스타',
      category: Category.western,
      preference: PreferenceCategory.western,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '6',
      name: '스테이크',
      category: Category.western,
      preference: PreferenceCategory.western,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.beef,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '7',
      name: '리조또',
      category: Category.western,
      preference: PreferenceCategory.western,
      dislikes: [
        DislikeCategory.rice,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),

    // 분식
    Menu(
      id: '8',
      name: '떡볶이',
      category: Category.korean,
      preference: PreferenceCategory.snack,
      dislikes: [
        DislikeCategory.soup,
        DislikeCategory.spicy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '9',
      name: '김밥',
      category: Category.korean,
      preference: PreferenceCategory.snack,
      dislikes: [DislikeCategory.rice],
    ),
    Menu(
      id: '10',
      name: '라면',
      category: Category.korean,
      preference: PreferenceCategory.snack,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.soup,
        DislikeCategory.spicy,
        DislikeCategory.warm,
      ],
    ),

    // 한식
    Menu(
      id: '11',
      name: '비빔밥',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [DislikeCategory.vegetable, DislikeCategory.rice],
    ),
    Menu(
      id: '12',
      name: '불고기',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.beef,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '13',
      name: '김치찌개',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.pork,
        DislikeCategory.rice,
        DislikeCategory.soup,
        DislikeCategory.spicy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '14',
      name: '된장찌개',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [
        DislikeCategory.rice,
        DislikeCategory.soup,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '15',
      name: '돼지국밥',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.pork,
        DislikeCategory.organ,
        DislikeCategory.rice,
        DislikeCategory.soup,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '16',
      name: '냉면',
      category: Category.korean,
      preference: PreferenceCategory.korean,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.soup,
        DislikeCategory.cold,
      ],
    ),
    Menu(
      id: '17',
      name: '삼겹살',
      category: Category.korean,
      preference: PreferenceCategory.meat,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.pork,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),

    // 일식
    Menu(
      id: '18',
      name: '초밥',
      category: Category.japanese,
      preference: PreferenceCategory.japanese,
      dislikes: [
        DislikeCategory.seafood,
        DislikeCategory.rawFish,
        DislikeCategory.rice,
      ],
    ),
    Menu(
      id: '19',
      name: '라멘',
      category: Category.japanese,
      preference: PreferenceCategory.japanese,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.soup,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '20',
      name: '우동',
      category: Category.japanese,
      preference: PreferenceCategory.japanese,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.soup,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '21',
      name: '돈카츠',
      category: Category.japanese,
      preference: PreferenceCategory.japanese,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.pork,
        DislikeCategory.greasy,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '22',
      name: '회',
      category: Category.japanese,
      preference: PreferenceCategory.japanese,
      dislikes: [
        DislikeCategory.seafood,
        DislikeCategory.rawFish,
        DislikeCategory.cold,
      ],
    ),

    // 중식
    Menu(
      id: '23',
      name: '짜장면',
      category: Category.chinese,
      preference: PreferenceCategory.chinese,
      dislikes: [DislikeCategory.noodle, DislikeCategory.warm],
    ),
    Menu(
      id: '24',
      name: '짬뽕',
      category: Category.chinese,
      preference: PreferenceCategory.chinese,
      dislikes: [
        DislikeCategory.noodle,
        DislikeCategory.spicy,
        DislikeCategory.warm,
        DislikeCategory.soup,
      ],
    ),
    Menu(
      id: '25',
      name: '마라탕',
      category: Category.chinese,
      preference: PreferenceCategory.chinese,
      dislikes: [
        DislikeCategory.spicy,
        DislikeCategory.warm,
        DislikeCategory.soup,
      ],
    ),
    Menu(
      id: '26',
      name: '양꼬치',
      category: Category.chinese,
      preference: PreferenceCategory.chinese,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.lamb,
        DislikeCategory.warm,
      ],
    ),

    // 아시안
    Menu(
      id: '27',
      name: '쌀국수',
      category: Category.others,
      preference: PreferenceCategory.asian,
      dislikes: [
        DislikeCategory.meat,
        DislikeCategory.beef,
        DislikeCategory.noodle,
        DislikeCategory.soup,
        DislikeCategory.warm,
      ],
    ),
    Menu(
      id: '28',
      name: '커리',
      category: Category.others,
      preference: PreferenceCategory.asian,
      dislikes: [DislikeCategory.warm],
    ),

    // 샐러드/샌드위치
    Menu(
      id: '29',
      name: '샐러드',
      category: Category.others,
      preference: PreferenceCategory.saladSandwich,
      dislikes: [DislikeCategory.vegetable, DislikeCategory.cold],
    ),
    Menu(
      id: '30',
      name: '샌드위치',
      category: Category.others,
      preference: PreferenceCategory.saladSandwich,
      dislikes: [DislikeCategory.cold],
    ),

    // 디저트
    Menu(
      id: '31',
      name: '아이스크림',
      category: Category.others,
      preference: PreferenceCategory.dessert,
      dislikes: [DislikeCategory.cold],
    ),
  ];

  @override
  Future<List<Menu>> getMenus() async {
    return _menus;
  }
}
