// This file Copyright © Mnemosyne LLC.
// It may be used under GPLv2 (SPDX: GPL-2.0-only), GPLv3 (SPDX: GPL-3.0-only),
// or any future license endorsed by Mnemosyne LLC.
// License text can be found in the licenses/ folder.

#import <Foundation/Foundation.h>

#include <string_view>

#include <libtransmission/utils.h>

#include "gtest/gtest.h"
#include "test-fixtures.h"

using UtilsTest = ::libtransmission::test::TransmissionTest;
using namespace std::literals;

TEST_F(UtilsTest, trStrvToUtf8NsstringValid)
{
    @autoreleasepool
    {
        NSString* str = tr_strv_to_utf8_nsstring("hello"sv);
        EXPECT_TRUE([str isEqualToString:@"hello"]);
    }
}

TEST_F(UtilsTest, trStrvToUtf8NsstringInvalid)
{
    @autoreleasepool
    {
        auto const bad = "\xF4\x33\x81\x82"sv;
        NSString* str = tr_strv_to_utf8_nsstring(bad);
        EXPECT_TRUE([str isEqualToString:@""]);
    }
}

TEST_F(UtilsTest, trStrvToUtf8NsstringFallback)
{
    @autoreleasepool
    {
        auto const bad = "\xF4\x33\x81\x82"sv;
        NSString* const key = @"tr.strv.to.utf8.fallback";
        NSString* const comment = @"fallback string for tests";
        NSString* str = tr_strv_to_utf8_nsstring(bad, key, comment);
        EXPECT_TRUE([str isEqualToString:key]);
    }
}

TEST_F(UtilsTest, trStrvToUtf8StringMixedInvalid)
{
    auto const input = "hello \xF0\x28\x8C\x28 world"sv;
    auto const expected = "hello \xEF\xBF\xBD world"sv; // U+FFFD replacement
    EXPECT_EQ(expected, tr_strv_to_utf8_string(input));
}
