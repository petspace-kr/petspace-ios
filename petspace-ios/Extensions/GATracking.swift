//
//  GATracking.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/15/23.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics

// 2023. 11. 15. 23:20
struct GATracking {
    // 가입 단계 (Welcome)
    struct RegisterStepsMessage {
        // Welcome View
        static let WELCOME_FIRST_APP_OPEN = "WELCOME_FIRST_APP_OPEN"
        static let WELCOME_PAGE_PROFILE_ADD_BUTTON = "WELCOME_PAGE_PROFILE_ADD_BUTTON"
        static let WELCOME_PAGE_PROFILE_PASS_BUTTON = "WELCOME_PAGE_PROFILE_PASS_BUTTON"
        static let WELCOME_PAGE_PROFILE_PASS_BUTTON_ADD = "WELCOME_PAGE_PROFILE_PASS_BUTTON_ADD"
        static let WELCOME_PAGE_PROFILE_PASS_BUTTON_PASS = "WELCOME_PAGE_PROFILE_PASS_BUTTON_PASS"
        
        // Profile View
        static let WELCOME_PROFILE_PAGE_REGISTERED = "WELCOME_PROFILE_PAGE_REGISTERED"
        static let WELCOME_PROFILE_PASS = "WELCOME_PROFILE_PASS"
        static let PROFILE_FIRST_REGISTERED_INFO = "PROFILE_FIRST_SAVE_INFO_" // + 견종, 무게, 사이즈, 무게
        static let PROFILE_FIRST_IS_IMAGE_REGISTERED = "PROFILE_FIRST_IS_IMAGE_REGISTERED" // 사진 등록 여부
        
        // Permission Page
        static let WELCOME_PERMISSION_PAGE_LOCATION_ALLOW = "WELCOME_PERMISSION_PAGE_LOCATION_ALLOW"
        static let WELCOME_PERMISSION_PAGE_LOCATION_DENIED = "WELCOME_PERMISSION_PAGE_LOCATION_DENIED"
        static let WELCOME_PERMISSION_PRECISE_LOCATION_ALLOW = "WELCOME_PERMISSION_PRECISE_LOCATION_ALLOW"
        static let WELCOME_PERMISSION_PAGE_FINISH = "WELCOME_PERMISSION_PAGE_FINISH" // 권한 페이지 완료
        
        // Beta Info View
        static let WELCOME_BETA_INFO_PAGE_FINISH = "WELCOME_BETA_INFO_PAGE_FINISH" // 베타 정보 뷰 완료
        
        // 최종 앱 접속 완료
        static let WELCOME_FINISH = "WELCOME_FINISH"
    }
    
    // 메인 화면
    struct MainViewMessage {
        // 앱 열고 닫기
        static let APP_OPEN = "APP_OPEN" // 앱 열기
        static let APP_TURN_FOREGROUND = "APP_TURN_FOREGROUND" // foreground 전환
        static let APP_TURN_BACKGROUND = "APP_TURN_BACKGROUND" // background 전환
        static let APP_QUIT = "APP_QUIT" // 앱 종료
        
        // 서버 접속 불가
        static let CANNOT_ACCESS_SERVER_ERROR = "CANNOT_ACCESS_SERVER_ERROR" // 네트워크 접근 불가
        
        // 정렬 순서 변경
        static let SORT_CHANGE_DISTANCE = "SORT_CHANGE_DISTANCE"
        static let SORT_CHANGE_RATING = "SORT_CHANGE_RATING"
        static let SORT_CHANGE_PRICE_INCREASE = "SORT_CHANGE_PRICE_INCREASE"
        static let SORT_CHANGE_PRICE_DECREASE = "SORT_CHANGE_PRICE_DECREASE"
        
        // 매장 상세 페이지로 이동, 닫기
        static let STORE_DETAIL_OPEN = "STORE_LIST_DETAIL_OPEN"
        static let STORE_DETAIL_CLOSE = "STORE_LIST_DETAIL_CLOSE"
        
        // 지도 Annotation
        static let MAP_ANNOTATION_CLICKED = "MAP_ANNOTATION_CLICKED"
        static let MAP_ANNOTATION_ROUTE_START = "MAP_ANNOTATION_ROUTE_START" // 경로 시작
        static let MAP_ANNOTATION_ROUTE_REFRESH = "MAP_ANNOTATION_ROUTE_REFRESH" // 경로 새로고침
        static let MAP_ANNOTATION_CALL = "MAP_ANNOTATION_CALL" // 전화
        static let MAP_ANNOTATION_DETAIL_OPEN = "MAP_ANNOTATION_DETAIL_OPEN"
        static let MAP_ANNOTATION_CLOSE = "MAP_ANNOTATION_CLOSE"
        
        // 검색
        static let SEARCH_START = "SEARCH_START" // 검색 버튼
        static let SEARCH_CANCEL = "SEARCH_CANCEL" // 검색 취소
        
        // 프로필 등록
        static let STORE_LIST_PROFILE_PAGE_OPEN = "STORE_LIST_PROFILE_PAGE_OPEN" // 프로필 페이지 열기
        static let STORE_LIST_PROFILE_PAGE_CLOSE = "STORE_LIST_PROFILE_PAGE_CLOSE" // 프로필 페이지 닫기
    }
    
    // Detail View
    struct DetailViewMessage {
        // Detail View
        static let DETAIL_PAGE_CALL_CLICK = "DETAIL_PAGE_CALL_CLICK"
        static let DETAIL_PAGE_SHOW_PRICE_TABLE = "DETAIL_PAGE_SHOW_PRICE_TABLE"
        static let DETAIL_PAGE_SHOW_MINIMAP = "DETAIL_PAGE_SHOW_MINIMAP"
    }
    
    // Button Bar View (ETC)
    struct EtcViewMessage {
        // 프로필 뷰
        static let BAR_PROFILE_PAGE_OPEN = "BAR_PROFILE_PAGE_OPEN"
        static let BAR_PROFILE_PAGE_CLOSE = "BAR_PROFILE_PAGE_CLOSE"
        
        // 예약 뷰
        static let BAR_BOOKING_PAGE_OPEN = "BAR_BOOKING_PAGE_OPEN"
        static let BAR_BOOKING_PAGE_CLOSE = "BAR_BOOKING_PAGE_CLOSE"
        
        // 정보 뷰
        static let BAR_INFO_PAGE_OPEN = "BAR_INFO_PAGE_OPEN"
        static let BAR_INFO_PAGE_CLOSE = "BAR_INFO_PAGE_CLOSE"
        
        // 아직 사용 X
        static let BAR_SETTING_PAGE_OPEN = "BAR_SETTING_PAGE_OPEN"
        static let BAR_SETTING_PAGE_CLOSE = "BAR_SETTING_PAGE_CLOSE"
        static let BAR_SAVED_SHOWING_ON = "BAR_SAVED_SHOWING_ON"
        static let BAR_SAVED_SHOWING_OFF = "BAR_SAVED_SHOWING_OFF"
    }
    
    // 프로필 (첫 등록 제외)
    struct ProfileViewMessage {
        // 프로필 저장 버튼
        static let PROFILE_PAGE_SAVE = "PROFILE_PAGE_SAVE"
        
        // 프로필 수정 버튼
        static let PROFILE_PAGE_EDIT_BUTTON = "PROFILE_PAGE_EDIT_BUTTON"
        
        // 프로필 수정 취소
        static let PROFILE_PAGE_EDIT_CANCEL_BUTTON = "PROFILE_PAGE_EDIT_CANCEL_BUTTON"
        
        // 프로필 저장
        static let PROFILE_PAGE_SAVE_INFO = "PROFILE_PAGE_SAVE_INFO_" // + 견종, 무게, 사이즈, 무게
        static let PROFILE_PAGE_EDIT_INFO = "PROFILE_PAGE_EDIT_INFO_" // 수정
        static let PROFILE_FIRST_IS_IMAGE_REGISTERED = "PROFILE_PAGE_IS_IMAGE_REGISTERED" // 사진 등록 여부
    }
    
    // Info View
    struct InfoViewMessage {
        static let INFO_PAGE_PRIVACY_OPEN = "INFO_PAGE_PRIVACY_OPEN"
        static let INFO_PAGE_PRIVACY_CLOSE = "INFO_PAGE_PRIVACY_CLOSE"
        
        // 권한 수정 버튼
        static let INFO_PAGE_EDIT_PRIVACY_BUTTON = "INFO_PAGE_EDIT_PRIVACY_BUTTON"
        static let INFO_PAGE_EDIT_PRIVACY_BUTTON_TO_SETTING = "INFO_PAGE_EDIT_PRIVACY_BUTTON_TO_SETTING"
        static let INFO_PAGE_EDIT_PRIVACY_BUTTON_PASS = "INFO_PAGE_EDIT_PRIVACY_BUTTON_PASS"
        
        // 오류 신고
        static let INFO_PAGE_ERROR_DECLARATION_BUTTON = "INFO_PAGE_ERROR_DECLARATION_BUTTON" // 버튼 열기
        static let INFO_PAGE_ERROR_DECLARATION_PASS = "INFO_PAGE_ERROR_DECLARATION_PASS" // 패스
        static let INFO_PAGE_ERROR_DECLARATION_COPY = "INFO_PAGE_ERROR_DECLARATION_COPY" // 메일 주소 복사
        static let INFO_PAGE_ERROR_DECLARATION_WRITE_MAIL = "INFO_PAGE_ERROR_DECLARATION_WRITE_MAIL" // 메일 작성
    }
    
    // 로그 전송
    static func sendLogEvent(eventName: String, params: [String : Any]?) {
        // user ID 가져오기
        let userID = ServerLogger.getUserID()
        
        // version 가져오기
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        Analytics.setUserID("userID=\(userID)")
        Analytics.setUserProperty(version, forName: "appVersion")
        Analytics.logEvent(eventName, parameters: params)
        
        if params == nil {
            print("GA LogEvent : \(eventName)")
        } else {
            print("GA LogEvent with params : \(eventName), msg: \(params!.description)")
        }
    }
}
