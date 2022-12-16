// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class MyProfileQuery: GraphQLQuery {
  public static let operationName: String = "MyProfile"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query MyProfile {
        myProfile {
          __typename
          userId
          firstName
          lastName
          sex
          birthDate
          telNumber
          about
          hobby
          blindSpotLat
          blindSpotLng
          blindSpotRadius
          notificattionsEnabled
          showPhoneNumber
          showBirthDate
          chipSearcheable
          phoneSearcheable
          social
          settings
        }
      }
      """
    ))

  public init() {}

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Query }
    public static var __selections: [Selection] { [
      .field("myProfile", MyProfile?.self),
    ] }

    public var myProfile: MyProfile? { __data["myProfile"] }

    /// MyProfile
    ///
    /// Parent Type: `Profile`
    public struct MyProfile: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.Profile }
      public static var __selections: [Selection] { [
        .field("userId", Aida.UUID.self),
        .field("firstName", String?.self),
        .field("lastName", String?.self),
        .field("sex", GraphQLEnum<Aida.SexEnum>?.self),
        .field("birthDate", Aida.Date?.self),
        .field("telNumber", String?.self),
        .field("about", String?.self),
        .field("hobby", Aida.JSONString?.self),
        .field("blindSpotLat", Double?.self),
        .field("blindSpotLng", Double?.self),
        .field("blindSpotRadius", Double?.self),
        .field("notificattionsEnabled", Bool.self),
        .field("showPhoneNumber", Bool.self),
        .field("showBirthDate", Bool.self),
        .field("chipSearcheable", Bool.self),
        .field("phoneSearcheable", Bool.self),
        .field("social", Aida.JSONString?.self),
        .field("settings", Aida.JSONString?.self),
      ] }

      public var userId: Aida.UUID { __data["userId"] }
      public var firstName: String? { __data["firstName"] }
      public var lastName: String? { __data["lastName"] }
      public var sex: GraphQLEnum<Aida.SexEnum>? { __data["sex"] }
      public var birthDate: Aida.Date? { __data["birthDate"] }
      public var telNumber: String? { __data["telNumber"] }
      public var about: String? { __data["about"] }
      public var hobby: Aida.JSONString? { __data["hobby"] }
      public var blindSpotLat: Double? { __data["blindSpotLat"] }
      public var blindSpotLng: Double? { __data["blindSpotLng"] }
      public var blindSpotRadius: Double? { __data["blindSpotRadius"] }
      public var notificattionsEnabled: Bool { __data["notificattionsEnabled"] }
      public var showPhoneNumber: Bool { __data["showPhoneNumber"] }
      public var showBirthDate: Bool { __data["showBirthDate"] }
      public var chipSearcheable: Bool { __data["chipSearcheable"] }
      public var phoneSearcheable: Bool { __data["phoneSearcheable"] }
      public var social: Aida.JSONString? { __data["social"] }
      public var settings: Aida.JSONString? { __data["settings"] }
    }
  }
}
