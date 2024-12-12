//
//  WorkspaceResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/06.
//

import XCTest
import AnthropicSwiftSDK

final class WorkspaceResponseTests: XCTestCase {
    func testDecodeWorkspaceResponse() throws {
        let json = """
        {
          "id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace",
          "name": "Workspace Name",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "archived_at": "2024-11-01T23:59:27.427722Z",
          "display_color": "#6C5BB9"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(WorkspaceResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .workspace)
        XCTAssertEqual(response.name, "Workspace Name")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.archivedAt, "2024-11-01T23:59:27.427722Z")
        XCTAssertEqual(response.displayColor, "#6C5BB9")
    }
}
